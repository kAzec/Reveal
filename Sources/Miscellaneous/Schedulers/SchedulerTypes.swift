//
//  SchedulerType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/2/24.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

/// Represents a serial queue of work items.
public protocol SchedulerType {
    /// Enqueues an action on the scheduler.
    ///
    /// When the work is executed depends on the scheduler in use.
    ///
    /// Optionally returns a disposable that can be used to cancel the work
    /// before it begins.
    func schedule(action: Void -> Void) -> Disposable?
}

public protocol DelaySchedulerType: SchedulerType {
    /// Schedules an action for execution at or after the given time.
    ///
    /// Optionally returns a disposable that can be used to cancel the work
    /// before it begins.
    func schedule(after delay: NSTimeInterval, action: Void -> Void) -> Disposable?
    
    /// Schedules a recurring action at the given interval, beginning at the
    /// given start time.
    ///
    /// Optionally returns a disposable that can be used to cancel the work
    /// before it begins.
    func schedule(after delay: NSTimeInterval, repeatingEvery: NSTimeInterval, withLeeway: NSTimeInterval, action: Void -> Void) -> Disposable?
}

public protocol DateSchedulerType: DelaySchedulerType {
    /// Schedules an action for execution at the given date.
    ///
    /// Optionally returns a disposable that can be used to cancel the work
    /// before it begins.
    func schedule(at date: NSDate, action: Void -> Void) -> Disposable?
    
    /// Schedules a recurring action at the given interval, beginning at the
    /// given start date.
    ///
    /// Optionally returns a disposable that can be used to cancel the work
    /// before it begins.
    func schedule(at date: NSDate, repeatingEvery: NSTimeInterval, withLeeway: NSTimeInterval, action: Void -> Void) -> Disposable?
}