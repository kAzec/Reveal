//
//  QueueScheduler.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/2/24.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

/// A scheduler backed by a serial GCD queue.
public final class QueueScheduler: DateSchedulerType{
    /// A singleton QueueScheduler that always targets the main thread's GCD
    /// queue.
    ///
    /// Unlike UIScheduler, this scheduler supports scheduling for a future
    /// date, and will always schedule asynchronously (even if already running
    /// on the main thread).
    public static let main = QueueScheduler(queue: dispatch_get_main_queue())
    
    internal let queue: dispatch_queue_t
    
    internal init(queue: dispatch_queue_t) {
        self.queue = queue
    }
    
    /// Initializes a scheduler that will target a new
    /// queue with the given attr.
    @available(iOS 8, watchOS 2, OSX 10.10, *)
    public convenience init(name: String, attr: dispatch_queue_attr_t = DISPATCH_QUEUE_SERIAL) {
        self.init(queue: dispatch_queue_create(name, attr))
    }
    
    @available(iOS 8, watchOS 2, OSX 10.10, *)
    public convenience init(name: String, attr: dispatch_queue_attr_t = DISPATCH_QUEUE_SERIAL, qos: dispatch_qos_class_t, priority: Int32) {
        self.init(name: name, attr: dispatch_queue_attr_make_with_qos_class(attr, qos, priority))
    }
    
    public func schedule(action: Void -> Void) -> Disposable? {
        let disposable = SimpleDisposable()
        
        dispatch_async(queue) {
            if !disposable.disposed {
                action()
            }
        }
        
        return disposable
    }
    
    public func schedule(after delay: NSTimeInterval, action: Void -> Void) -> Disposable? {
        let disposable = SimpleDisposable()
        
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(when, queue) {
            if !disposable.disposed {
                action()
            }
        }
        
        return disposable
    }
    
    public func schedule(after delay: NSTimeInterval, repeatingEvery repeatingInterval: NSTimeInterval, withLeeway leeway: NSTimeInterval, action: Void -> Void) -> Disposable? {
        precondition(repeatingInterval >= 0)
        precondition(leeway >= 0)
        
        let nsecInterval = repeatingInterval * Double(NSEC_PER_SEC)
        let nsecLeeway = leeway * Double(NSEC_PER_SEC)
        
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_source_set_timer(timer, when, UInt64(nsecInterval), UInt64(nsecLeeway))
        dispatch_source_set_event_handler(timer, action)
        dispatch_resume(timer)
        
        return TimerDisposable(timer)
    }
    
    public func schedule(at date: NSDate, action: Void -> Void) -> Disposable? {
        let disposable = SimpleDisposable()
        
        dispatch_after(wallTimeWithDate(date), queue) {
            if !disposable.disposed {
                action()
            }
        }
        
        return disposable
    }
    
    /// Schedules a recurring action at the given interval, beginning at the
    /// given start time, and with a reasonable default leeway.
    ///
    /// Optionally returns a disposable that can be used to cancel the work
    /// before it begins.
    public func schedule(at date: NSDate, repeatingEvery: NSTimeInterval, action: Void -> Void) -> Disposable? {
        // Apple's "Power Efficiency Guide for Mac Apps" recommends a leeway of
        // at least 10% of the timer interval.
        return schedule(at: date, repeatingEvery: repeatingEvery, withLeeway: repeatingEvery * 0.1, action: action)
    }
    
    public func schedule(at date: NSDate, repeatingEvery repeatingInterval: NSTimeInterval, withLeeway leeway: NSTimeInterval, action: Void -> Void) -> Disposable? {
        precondition(repeatingInterval >= 0)
        precondition(leeway >= 0)
        
        let nsecInterval = repeatingInterval * Double(NSEC_PER_SEC)
        let nsecLeeway = leeway * Double(NSEC_PER_SEC)
        
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        dispatch_source_set_timer(timer, wallTimeWithDate(date), UInt64(nsecInterval), UInt64(nsecLeeway))
        dispatch_source_set_event_handler(timer, action)
        dispatch_resume(timer)
        
        return TimerDisposable(timer)
    }
    
    private func wallTimeWithDate(date: NSDate) -> dispatch_time_t {
        
        let (seconds, frac) = modf(date.timeIntervalSince1970)
        
        let nsec: Double = frac * Double(NSEC_PER_SEC)
        var walltime = timespec(tv_sec: Int(seconds), tv_nsec: Int(nsec))
        
        return dispatch_walltime(&walltime, 0)
    }
}

private final class TimerDisposable: Disposable {
    var atomicDisposed = AtomicBool(false)
    var timer: dispatch_source_t?
    
    init(_ timer: dispatch_source_t) {
        self.timer = timer
    }
    
    func dispose() {
        if !atomicDisposed.swap(true) {
            let timer = self.timer!
            self.timer = nil
            dispatch_source_cancel(timer)
        }
    }
    
    var disposed: Bool {
        return atomicDisposed.boolValue
    }
}