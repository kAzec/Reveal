//
//  TakeTime.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/3.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

final class TakeTime<T, Scheduler: DelaySchedulerType>: ControlWithTime<T, Scheduler> {
    private var shouldTake: AtomicBool {
        return controlValue
    }
    
    override init(_ time: NSTimeInterval, scheduler: Scheduler) {
        super.init(time, scheduler: scheduler)
    }
    
    override func forward(sink: T -> Void) -> (T -> Void) {
        guard timeLimit > 0 else { return { [sink] _ in let _ = sink } }
        
        return { value in
            guard self.shouldTake else { return }
            self.scheduleFlip()
            sink(value)
        }
    }
}