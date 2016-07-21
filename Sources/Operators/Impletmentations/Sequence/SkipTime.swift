//
//  SkipTime.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

final class SkipTime<Element, Scheduler: DelaySchedulerType>: ControlWithTime<Element, Scheduler> {
    private var shouldSkip: Bool {
        return controlValue.boolValue
    }
    
    override init(_ time: NSTimeInterval, scheduler: Scheduler) {
        super.init(time, scheduler: scheduler)
    }
    
    override func forward(sink: Element -> Void) -> (Element -> Void) {
        guard timeLimit > 0 else { return { sink($0) } }
        
        return { value in
            if self.shouldSkip {
                self.scheduleFlip()
                return
            }
            
            sink(value)
        }
    }
}