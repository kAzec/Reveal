//
//  ControlWithTrigger.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/9.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class ControlWithTrigger<T, Trigger: SourceType>: ValueCustomOperator<T, T> {
    private let trigger: Trigger
    private let predicate: Trigger.Element -> Bool
    private var subscription: Subscription<Trigger>?
    
    private var controlValue = true
    
    var exceptation: Bool {
        RevealUnimplemented()
    }
    
    init(_ trigger: Trigger, predicate: Trigger.Element -> Bool) {
        self.trigger = trigger
        self.predicate = predicate
    }
    
    deinit {
        subscription?.dispose()
    }
    
    final override func forward(sink: T -> Void) -> (T -> Void) {
        subscription?.dispose()
        subscription = trigger.subscribe { [unowned self] value in
            self.controlValue = self.controlValue && !self.predicate(value)
        }
        
        let exceptation = self.exceptation
        
        return { value in
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