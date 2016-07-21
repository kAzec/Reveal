//
//  ControlWithTime.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/9.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

class ControlWithTime<T, Scheduler: DelaySchedulerType>: ValueCustomOperator<T, T> {
    let timeLimit: NSTimeInterval
    let scheduler: Scheduler
    var controlValue = AtomicBool(true)
    var scheduled = AtomicBool(false)
    
    init(_ time: NSTimeInterval, scheduler: Scheduler) {
        precondition(time >= 0)
        
        timeLimit = time
        self.scheduler = scheduler
    }
    
    final func scheduleFlip() {
        if !scheduled.swap(true) {
            scheduler.schedule(after: timeLimit) { [weak self] in
                self?.controlValue.swap(false)
            }
        }
    }
    
    final override func forwardCompletion(completion completionSink: Void -> Void, next nextSink: T -> Void) -> (Void -> Void) {
        return {
            self.controlValue.swap(false)
            completionSink()
        }
    }
}