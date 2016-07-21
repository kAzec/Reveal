//
//  Timeout.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

final class Timeout<T, Scheduler: DelaySchedulerType>: ValueDefaultOperator<T, T> {
    private let dueTime: NSTimeInterval
    private let expectation: (T -> Bool)
    private let consequence: (Void -> Void)
    private let scheduler: Scheduler
    private let disposable = SerialDisposable()
    
    init(dueTime: NSTimeInterval, scheduler: Scheduler, expectation: (T -> Bool), consequence: (Void -> Void)) {
        self.dueTime = dueTime
        self.scheduler = scheduler
        self.expectation = expectation
        self.consequence = consequence
    }
    
    deinit {
        disposable.dispose()
    }
    
    override func forward(sink: T -> Void) -> (T -> Void) {
        var didTimeout = AtomicBool(false)
        
        func scheduleNewTimeout() {
            let scheduledDisposable = scheduler.schedule(after: dueTime) {
                guard !didTimeout.swap(true) else { return }
                
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