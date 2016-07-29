//
//  Coalesce.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/9.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Coalesce<T, Scheduler: DelaySchedulerType>: AsyncOperator<T, [T], Scheduler> {
    private let interval: NSTimeInterval
    private let coalesced = Atomic<[T]>([])
    private let scheduledDisposable = SerialDisposable()
    
    init(interval: NSTimeInterval, scheduler: Scheduler) {
        self.interval = interval
        super.init(scheduler: scheduler)
    }
    
    override func forward(sink: Sink) -> Source {
        return { element in
            self.coalesced.modify { coalesced in
                let isEmpty = coalesced.isEmpty
                coalesced.append(element)
                
                if isEmpty {
                    self.scheduledDisposable.innerDisposable = self.schedule(after: self.interval) { weakSelf in
                        sink(weakSelf.coalesced.swap([]))
                    }
                }
            }
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void)? {
        return {
            self.scheduledDisposable.dispose()
            self.schedule { weakSelf in
                let coalesced = weakSelf.coalesced.swap([])
                if !coalesced.isEmpty {
                    valueSink(coalesced)
                }
                
                completionSink()
            }
        }
    }
}