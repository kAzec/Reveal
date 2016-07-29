//
//  DeliverOn.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/17.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class DeliverOn<T, Scheduler: SchedulerType>: ValueOperator<T, T>, AsyncType {
    final let scheduler: Scheduler
    final let lock = NSLock()
    
    init(scheduler: Scheduler) {
        self.scheduler = scheduler
        lock.name = String(self.dynamicType)
    }
    
    override func forward(sink: Sink) -> Source {
        return { value in
            self.schedule { _ in
                sink(value)
            }
        }
    }
}