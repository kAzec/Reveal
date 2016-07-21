//
//  Debounce.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

final class Debounce<T, Scheduler: DelaySchedulerType>: AsyncOperator<T, T, Scheduler> {
    private let timeout: NSTimeInterval
    private var receivedBeforeTimeout = false
    private var forwardNeeded = true
    private let latest = Atomic<T?>(nil)
    
    init(timeout: NSTimeInterval, scheduler: Scheduler) {
        self.timeout = timeout
        super.init(scheduler: scheduler)
    }
    
    override func forward(sink: T -> Void) -> (T -> Void) {
        return { value in
            self.latest.swap { _ in
                self.forwardNeeded = !self.receivedBeforeTimeout
                self.receivedBeforeTimeout = true
                
                self.schedule(after: self.timeout) { [weak self] in
                    guard let weakSelf = self else { return }
                    
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