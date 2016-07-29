//
//  Delay.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Delay<T, Scheduler: DelaySchedulerType>: AsyncOperator<T, T, Scheduler> {
    private let interval: NSTimeInterval
    
    init(interval: NSTimeInterval, scheduler: Scheduler) {
        self.interval = interval
        super.init(scheduler: scheduler)
    }
    
    override func forward(sink: Sink) -> Source {
        return { value in
            self.schedule(after: self.interval) { _ in
                sink(value)
            }
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void)? {
        return {
            self.schedule(after: self.interval) { _ in
                completionSink()
            }
        }
    }
}