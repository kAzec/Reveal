//
//  Throttle.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/3.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Throttle<T, Scheduler: DelaySchedulerType>: AsyncOperator<T, T, Scheduler> {
    private let interval: NSTimeInterval
    private let latest = Atomic<T?>(nil)
    
    init(interval: NSTimeInterval, scheduler: Scheduler) {
        self.interval = interval
        super.init(scheduler: scheduler)
    }
    
    override func forward(sink: Sink) -> Source {
        guard interval > 0 else {
            return sink
        }
        
        return { element in
            self.latest.swap { old in
                if old == nil {
                    self.schedule(after: self.interval) { weakSelf in
                        sink(weakSelf.latest.swap(nil)!)
                    }
                }
                
                return element
            }
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void)? {
        return {
            self.schedule { weakSelf in
                weakSelf.latest.swap(nil)
                completionSink()
            }
        }
    }
}