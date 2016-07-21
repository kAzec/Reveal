//
//  ControlWithPredicate.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/9.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class ControlWithPredicate<T>: ValueCustomOperator<T, T> {
    private let predicate: T -> Bool
    private var controlValue = true
    
    var exceptation: Bool {
        RevealUnimplemented()
    }
    
    init(_ predicate: T -> Bool) {
        self.predicate = predicate
    }
    
    final override func forward(sink: T -> Void) -> (T -> Void) {
        let exceptation = self.exceptation
        
        return { value in
            self.controlValue = self.controlValue && self.predicate(value)
            if self.controlValue == exceptation {
                sink(value)
            }
        }
    }
    
    final override func forwardCompletion(completion completionSink: Void -> Void, next nextSink: T -> Void) -> (Void -> Void) {
        return {
            self.controlValue = true
            completionSink()
        }
    }
}