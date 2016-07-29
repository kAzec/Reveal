//
//  Timeout.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Timeout<T, Scheduler: DelaySchedulerType>: ValueDefaultOperator<T, T> {
    private let interval: NSTimeInterval
    private let expectation: (T -> Bool)
    private let consequence: (Void -> Void)
    private let scheduler: Scheduler
    private var didTimeout = AtomicBool(false)
    private let disposable = SerialDisposable()
    
    init(interval: NSTimeInterval, scheduler: Scheduler, expectation: (T -> Bool), consequence: (Void -> Void)) {
        self.interval = interval
        self.scheduler = scheduler
        self.expectation = expectation
        self.consequence = consequence
    }
    
    deinit {
        disposable.dispose()
    }
    
    override func forward(sink: Sink) -> Source {
        func scheduleNewTimeout() {
            let scheduledDisposable = scheduler.schedule(after: interval) {
                if self.didTimeout.swap(true) { return }
                
                self.consequence()
            }
            
            disposable.innerDisposable = scheduledDisposable
        }
        
        scheduleNewTimeout()
        
        return { value in
            if self.expectation(value) {
                scheduleNewTimeout()
            }
            
            sink(value)
        }
    }
}