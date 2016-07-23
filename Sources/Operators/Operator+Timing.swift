//
//  Operator+Timing.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/24.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public func coalesce<T, Scheduler: DelaySchedulerType>(interval: NSTimeInterval, on scheduler: Scheduler) -> ValueOperator<T, [T]> {
    return Coalesce(interval: interval, scheduler: scheduler)
}

public func debounce<T, Scheduler: DelaySchedulerType>(interval: NSTimeInterval, on scheduler: Scheduler) -> ValueOperator<T, T> {
    return Debounce(interval: interval, scheduler: scheduler)
}

public func delay<T, Scheduler: DelaySchedulerType>(interval: NSTimeInterval, on scheduler: Scheduler) -> ValueOperator<T, T> {
    return Delay(interval: interval, scheduler: scheduler)
}

public func throttle<T, Scheduler: DelaySchedulerType>(interval: NSTimeInterval, on scheduler: Scheduler) -> ValueOperator<T, T> {
    return Throttle(interval: interval, scheduler: scheduler)
}

public func timeout<T: Equatable, Scheduler: DelaySchedulerType>(for value: T, after interval: NSTimeInterval, on scheduler: Scheduler, timeout onTimeout: Void -> Void) -> ValueOperator<T, T> {
    return Timeout(interval: interval, scheduler: scheduler, expectation: { $0 == value }, consequence: onTimeout)
}

public func timeout<T: Equatable, Scheduler: DelaySchedulerType>(using predicate: T -> Bool, after interval: NSTimeInterval, on scheduler: Scheduler, timeout onTimeout: Void -> Void) -> ValueOperator<T, T> {
    return Timeout(interval: interval, scheduler: scheduler, expectation: predicate, consequence: onTimeout)
}

public func timeout<T: Equatable, E, Scheduler: DelaySchedulerType>(for value: T, after interval: NSTimeInterval, with error: E, on scheduler: Scheduler, timeout onTimeout: (Void -> Void)? = nil) -> ResponseOperator<T, E, T, E> {
    return TimeoutWithError(interval: interval, scheduler: scheduler, error: error, expectation: { $0 == value }, consequence: onTimeout)
}

public func timeout<T: Equatable, E, Scheduler: DelaySchedulerType>(using predicate: T -> Bool, after interval: NSTimeInterval, with error: E, on scheduler: Scheduler, timeout onTimeout: (Void -> Void)? = nil) -> ResponseOperator<T, E, T, E> {
    return TimeoutWithError(interval: interval, scheduler: scheduler, error: error, expectation: predicate, consequence: onTimeout)
}

public func timeout<T, E, Scheduler: DelaySchedulerType>(after interval: NSTimeInterval, with error: E, on scheduler: Scheduler, timeout onTimeout: (Void -> Void)? = nil) -> ResponseOperator<T, E, T, E> {
    return TimeoutWithError(interval: interval, scheduler: scheduler, error: error, expectation: nil, consequence: onTimeout)
}