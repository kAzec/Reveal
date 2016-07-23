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
    private let isTriggerTerminating: (Trigger.Element -> Bool)?
    private var subscription: Subscription<Trigger>?
    
    private var controlValue = AtomicBool(true)
    
    var exceptation: Bool {
        RevealUnimplemented()
    }
    
    init(_ trigger: Trigger, predicate isTriggerTerminating: (Trigger.Element -> Bool)?) {
        self.trigger = trigger
        self.isTriggerTerminating = isTriggerTerminating
    }
    
    deinit {
        subscription?.dispose()
    }
    
    final override func forward(sink: T -> Void) -> (T -> Void) {
        subscription?.dispose()
        subscription = trigger.subscribe { [unowned self] value in
            guard self.controlValue else { return }
            
            if self.isTriggerTerminating?(value) ?? false {
                self.subscription?.dispose()
            } else {
                self.controlValue.swap(false)
            }
        }
        
        let exceptation = self.exceptation
        
        return { value in
            if self.controlValue.boolValue == exceptation {
                sink(value)
            }
        }
    }
    
    final override func forwardCompletion(completion completionSink: Void -> Void, next nextSink: T -> Void) -> (Void -> Void) {
        return {
            self.controlValue.swap(true)
            completionSink()
        }
    }
}