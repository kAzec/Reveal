//
//  Coalesce.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/9.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

final class Coalesce<T, Scheduler: DelaySchedulerType>: AsyncOperator<T, [T], Scheduler> {
    private let interval: NSTimeInterval
    private let coalesced = Atomic<[T]>([])
    
    init(interval: NSTimeInterval, scheduler: Scheduler) {
        self.interval = interval
        super.init(scheduler: scheduler)
    }
    
    override func forward(sink: [T] -> Void) -> (T -> Void) {
        return { element in
            self.coalesced.modify { coalesced in
                let isEmpty = coalesced.isEmpty
                coalesced.append(element)
                
                if isEmpty {
                    self.schedule(after: self.interval) { [weak self] in
                        guard let weakSelf = self else { return }
                        
                        sink(weakSelf.coalesced.swap([]))
                    }
                }
            }
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next nextSink: [T] -> Void) -> (Void -> Void)? {
        return {
            self.schedule {
                let coalesced = self.coalesced.swap([])
                if !coalesced.isEmpty {
                    nextSink(coalesced)
                }
                
                completionSink()
            }
        }
    }
}