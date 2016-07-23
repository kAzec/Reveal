//
//  Operator+Async.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/24.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public func deliver<T, Scheduler: SchedulerType>(on scheduler: Scheduler) -> ValueOperator<T, T> {
    return DeliverOn(scheduler: scheduler)
}