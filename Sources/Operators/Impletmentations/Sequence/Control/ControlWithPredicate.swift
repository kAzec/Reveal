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
    private var succeeded = true
    
    var exceptation: Bool {
        RevealUnimplemented()
    }
    
    final var completionSink: (Void -> Void)?
    
    var onPredicateFailure: (Void -> Void)? {
        return nil
    }
    
    init(_ predicate: T -> Bool) {
        self.predicate = predicate
    }
    
    final override func forward(sink: Sink) -> Source {
        let exceptation = self.exceptation
        
        return { value in
            if self.succeeded && !self.predicate(value) {
                self.succeeded = false
                
                self.onPredicateFailure?()
            }
            
            if self.succeeded == exceptation {
                sink(value)
            }
        }
    }
    
    final override func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void) {
        self.completionSink = completionSink
        return completionSink
    }
}