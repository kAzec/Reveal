//
//  UIScheduler.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/2/24.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

/// A scheduler that performs all work on the main thread, as soon as possible.
///
/// If the caller is already running on the main thread when an action is
/// scheduled, it may be run synchronously. However, ordering between actions
/// will always be preserved.
public final class UIScheduler: SchedulerType {
    private var queueLength: Int32 = 0
    
    public init() {  }
    
    public func schedule(action: Void -> Void) -> Disposable? {
        let disposable = SimpleDisposable()
        
        let actionAndDecrement: Void -> Void = {
            if !disposable.disposed {
                action()
            }
            
            OSAtomicDecrement32(&self.queueLength)
        }
        
        let queued = OSAtomicIncrement32(&queueLength)
        
        // If we're already running on the main thread, and there isn't work
        // already enqueued, we can skip scheduling and just execute directly.
        if NSThread.isMainThread() && queued == 1 {
            actionAndDecrement()
        } else {
            dispatch_async(dispatch_get_main_queue(), actionAndDecrement)
        }
        
        return disposable
    }
}