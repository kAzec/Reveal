//
//  StreamObserver.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public struct StreamObserver<Value> {
    public typealias Action = Signal<Value> -> Void
    
    let action: Action
    
    public init(_ action: Action) {
        self.action = action
    }
    
    public init(next onNext: Value -> Void) {
        self.action = { signal in
            if case .next(let value) = signal {
                onNext(value)
            }
        }
    }
    
    public init(completion onCompletion: Void -> Void) {
        self.action = { signal in
            if case .completed = signal {
                onCompletion()
            }
        }
    }
    
    public init(next onNext: (Value -> Void)? = nil, completion onCompletion: (Void -> Void)? = nil) {
        self.action = { signal in
            switch signal {
            case .next(let value):
                onNext?(value)
            case .completed:
                onCompletion?()
            }
        }
    }
    
    public func next(value: Value) {
        action(.next(value))
    }
    
    public func complete() {
        action(.completed)
    }
    
    public func finally(value: Value) {
        action(.next(value))
        action(.completed)
    }
}

public extension Stream {
    typealias Observer = StreamObserver<Value>
    
    class func pipe() -> (Stream, Observer) {
        var observer: Observer!
        let stream = Stream { action in
            observer = Observer(action)
            return nil
        }
        
        return (stream, observer)
    }
}