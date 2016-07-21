//
//  OperationObserver.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public struct OperationObserver<Value, Error: ErrorType> {
    public typealias Action = Response<Value, Error> -> Void
    
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
    
    public init(failure onFailure: Error -> Void) {
        self.action = { signal in
            if case .failed(let error) = signal {
                onFailure(error)
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
    
    public init(next onNext: (Value -> Void)? = nil, failure onFailure: (Error -> Void)? = nil, completion onCompletion: (Void -> Void)? = nil) {
        self.action = { signal in
            switch signal {
            case .next(let value):
                onNext?(value)
            case .failed(let error):
                onFailure?(error)
            case .completed:
                onCompletion?()
            }
        }
    }
    
    public func next(value: Value) {
        action(.next(value))
    }
    
    public func fail(error: Error) {
        action(.failed(error))
    }
    
    public func complete() {
        action(.completed)
    }
    
    public func finally(value: Value) {
        action(.next(value))
        action(.completed)
    }
}

public extension Operation {
    typealias Observer = OperationObserver<Value, Error>
    
    class func pipe() -> (Operation, Observer) {
        var observer: Observer!
        let operation = Operation { action in
            observer = Observer(action)
            return nil
        }
        
        return (operation, observer)
    }
}