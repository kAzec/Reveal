//
//  ImmediateScheduler.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/2/24.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

/// A scheduler that performs all work synchronously.
public final class ImmediateScheduler: SchedulerType {
    public init() {}
    
    public func schedule(action: () -> ()) -> Disposable? {
        action()
        return nil
    }
}