//
//  TimeoutWithError.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/17.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

final class TimeoutWithError<T, E: ErrorType, Scheduler: DelaySchedulerType>: ResponseOperator<T, E, T, E> {
    private let delay: NSTimeInterval
    private let scheduler: Scheduler
    private let error: E
    private let expectation: (T -> Bool)?
    private let consequence: (Void -> Void)?
    private var didTimeout = AtomicBool(false)
    private let disposable = SerialDisposable()
    
    init(delay: NSTimeInterval, scheduler: Scheduler, error: E, expectation: (T -> Bool)?, consequence: (Void -> Void)?) {
        self.delay = delay
        self.scheduler = scheduler
        self.error = error
        self.expectation = expectation
        self.consequence = consequence
    }
    
    deinit {
        disposable.dispose()
    }
    
    override func forward(sink: Response<T, E>.Action) -> Response<T, E> -> Void {
        func scheduleNewTimeout() {
            let scheduledDisposable = scheduler.schedule(after: delay) {
                guard !self.didTimeout.swap(true) else { return }
                
                self.consequence?()
                sink(.failed(self.error))
            }
            
            disposable.innerDisposable = scheduledDisposable
        }
        
        scheduleNewTimeout()
        
        if let expectation = expectation {
            return { response in
                switch response {
                case .next(let value):
                    if expectation(value) {
                        scheduleNewTimeout()
                    }
                    
                    fallthrough
                default:
                    sink(response)
                }
            }
        } else {
            return { response in
                switch response {
                case .completed:
                    // Cancel scheduled timeout.
                    self.disposable.dispose()
                    fallthrough
                default:
                    sink(response)
                }
            }
        }
    }
}