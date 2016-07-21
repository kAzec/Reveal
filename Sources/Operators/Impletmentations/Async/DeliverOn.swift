//
//  DeliverOn.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/17.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class DeliverOn<T, Scheduler: SchedulerType>: AsyncOperator<T, T, Scheduler> {
    override init(scheduler: Scheduler) {
        super.init(scheduler: scheduler)
    }
    
    override func forward(sink: T -> Void) -> (T -> Void) {
        return { value in
            self.schedule {
                sink(value)
            }
        }
    }
}