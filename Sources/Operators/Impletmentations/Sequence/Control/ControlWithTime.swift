//
//  ControlWithTime.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/9.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class ControlWithTime<T, Scheduler: DelaySchedulerType>: ValueCustomOperator<T, T>, AsyncType {
    final let scheduler: Scheduler
    final let lock = NSLock()
    
    final let time: NSTimeInterval
    final var fliped = false
    private var scheduled = Atomic(false)
    
    final var completionSink: (Void -> Void)?
    
    var onFlip: (Void -> Void)? {
        return nil
    }
    
    init(_ time: NSTimeInterval, scheduler: Scheduler) {
        precondition(time >= 0)
        
        self.time = time
        self.scheduler = scheduler
        lock.name = String(self.dynamicType)
    }
    
    final func scheduleFlipOnce() {
        if scheduled.swap(true) { return }
        
        schedule(after: time) { weakSelf in
            weakSelf.fliped = true
            weakSelf.onFlip?()
        }
    }
    
    final override func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void) {
        self.completionSink = completionSink
        return completionSink
    }
}