//
//  ControlWIthCount.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/9.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class ControlWithCount<T>: ValueCustomOperator<T, T> {
    let countLimit: Int
    var controlValue = true
    var count = 0
    
    init(_ count: Int) {
        self.countLimit = count
    }
    
    final func increment() {
        self.count += 1
        if self.count >= self.countLimit {
            self.controlValue = false
        }
    }
    
    final override func forwardCompletion(completion completionSink: Void -> Void, next nextSink: T -> Void) -> (Void -> Void) {
        return {
            self.count = 0
            self.controlValue = false
            completionSink()
        }
    }
}