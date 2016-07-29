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
    private let predicate: (Trigger.Element -> Bool)?
    private var subscription: Disposable?
    
    private var triggered = false
    private let lock = NSLock()
    
    var completionSink: (Void -> Void)?
    
    var onTrigger: (Void -> Void)? {
        return nil
    }
    
    var exceptation: Bool {
        RevealUnimplemented()
    }
    
    init(_ trigger: Trigger, predicate: (Trigger.Element -> Bool)?) {
        self.trigger = trigger
        self.predicate = predicate
        lock.name = String(self.dynamicType)
    }
    
    deinit {
        subscription?.dispose()
    }
    
    final override func forward(sink: Sink) -> Source {
        subscription = trigger.subscribe { [unowned self] value in
            guard !self.triggered else { return }
            
            if self.predicate?(value) ?? false {
                self.subscription!.dispose()
            } else {
                self.lock.lock()
                defer { self.lock.unlock() }
                
                self.triggered = true
                self.onTrigger?()
            }
        }
        
        let exceptation = self.exceptation
        
        return { value in
            if self.triggered == exceptation {
                self.lock.lock()
                defer { self.lock.unlock() }
                
                sink(value)
            }
        }
    }
    
    final override func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void) {
        self.completionSink = completionSink
        return completionSink
    }
}