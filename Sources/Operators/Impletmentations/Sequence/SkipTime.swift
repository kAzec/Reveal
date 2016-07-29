//
//  SkipTime.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class SkipTime<Element, Scheduler: DelaySchedulerType>: ControlWithTime<Element, Scheduler> {
    override init(_ time: NSTimeInterval, scheduler: Scheduler) {
        super.init(time, scheduler: scheduler)
    }
    
    override func forward(sink: Sink) -> Source {
        guard time > 0 else { return sink }
        
        return { value in
            self.scheduleFlipOnce()
            
            if self.fliped {
                self.lock.lock()
                defer { self.lock.lock() }
                sink(value)
            }
        }
    }
}