//
//  Faults.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/28.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public struct NodeFault<Value>: FaultType, NodeProxyType {
    public var node: Node<Value> {
        return fire().0
    }
    
    let observee: (Value -> Void) -> Disposable
    let lazy = Box<(Node<Value>, Disposable)?>(nil)
    
    init(_ observee: (Value -> Void) -> Disposable) {
        self.observee = observee
    }
}

public struct StreamFault<Value>: FaultType, StreamProxyType {
    public var stream: Stream<Value> {
        return fire().0
    }

    let observee: Signal<Value>.Action -> Disposable
    let lazy = Box<(Stream<Value>, Disposable)?>(nil)
    
    init(_ observee: Signal<Value>.Action -> Disposable) {
        self.observee = observee
    }
}

public struct OperationFault<Value, Error: ErrorType>: FaultType, OperationProxyType {
    public var operation: Operation<Value, Error> {
        return fire().0
    }

    let observee: Response<Value, Error>.Action -> Disposable
    let lazy = Box<(Operation<Value, Error>, Disposable)?>(nil)
    
    init(_ observee: Response<Value, Error>.Action -> Disposable) {
        self.observee = observee
    }
}