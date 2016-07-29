//
//  Debounce.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Debounce<T, Scheduler: DelaySchedulerType>: AsyncOperator<T, T, Scheduler> {
    private let interval: NSTimeInterval
    private var receivedBeforeTimeout = false
    private var forwardNeeded = true
    private let latest = Atomic<T?>(nil)
    
    init(interval: NSTimeInterval, scheduler: Scheduler) {
        self.interval = interval
        super.init(scheduler: scheduler)
    }
    
    override func forward(sink: Sink) -> Source {
        return { value in
            self.latest.swap { _ in
                self.forwardNeeded = !self.receivedBeforeTimeout
                self.receivedBeforeTimeout = true
                
                self.schedule(after: self.interval) { weakSelf in
                    if weakSelf.forwardNeeded {
                        sink(weakSelf.latest.swap(nil)!)
                    }
                    
                    weakSelf.receivedBeforeTimeout = false
                }
                
                return value
            }
        }
    }
}