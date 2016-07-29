//
//  TakeTime.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/3.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class TakeTime<T, Scheduler: DelaySchedulerType>: ControlWithTime<T, Scheduler> {
    override init(_ time: NSTimeInterval, scheduler: Scheduler) {
        super.init(time, scheduler: scheduler)
    }
    
    override func forward(sink: Sink) -> Source {
        guard time > 0 else {
            completionSink?()
            return { _ in }
        }
        
        return { value in
            if self.fliped { return }
            self.scheduleFlipOnce()
            sink(value)
        }
    }
    
    override var onFlip: (Void -> Void)? {
        return completionSink
    }
}