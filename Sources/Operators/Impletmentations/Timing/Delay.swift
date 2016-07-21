//
//  Delay.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Delay<T, Scheduler: DelaySchedulerType>: AsyncOperator<T, T, Scheduler> {
    private let delay: NSTimeInterval
    
    init(delay: NSTimeInterval, scheduler: Scheduler) {
        self.delay = delay
        super.init(scheduler: scheduler)
    }
    
    override func forward(sink: T -> Void) -> (T -> Void) {
        return { value in
            self.schedule(after: self.delay) {
                sink(value)
            }
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next nextSink: T -> Void) -> (Void -> Void)? {
        return {
            self.schedule(after: self.delay) {
                completionSink()
            }
        }
    }
}