//
//  ControlWIthCount.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/9.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class ControlWithCount<T>: ValueCustomOperator<T, T> {
    final let limit: Int
    final var current = 0
    final var exceeded = false
    
    final var completionSink: (Void -> Void)?
    
    var onExceedingLimit: (Void -> Void)? {
        return nil
    }
    
    init(_ count: Int) {
        self.limit = count
    }
    
    final func increment() {
        current += 1
        if current >= limit {
            exceeded = true
            onExceedingLimit?()
        }
    }
    
    final override func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void) {
        self.completionSink = completionSink
        return completionSink
    }
}