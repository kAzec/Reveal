//
//  Actives.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/25.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - ActiveNode class
public struct ActiveNode<Value>: ActiveType, NodeProxyType {
    public typealias Proxy = Node<Value>
    
    public let node: Node<Value>
    
    public init(_ name: String) {
        node = Node(name)
    }
    
    public func send(value: Value) {
        node.on(value)
    }
}

// MARK: - ActiveStream class
public struct ActiveStream<Value>: ActiveType, StreamProxyType {
    public typealias Proxy = Stream<Value>
    
    public let stream: Stream<Value>
    
    public init(_ name: String) {
        stream = Stream(name)
    }
    
    public func send(signal: Signal<Value>) {
        stream.on(signal)
    }
}

// MARK: - ActiveOperation class
public struct ActiveOperation<Value, Error: ErrorType>: ActiveType, OperationProxyType {
    public typealias Proxy = Operation<Value, Error>
    
    public let operation: Operation<Value, Error>
    
    public init(_ name: String) {
        operation = Operation(name)
    }
    
    public func send(response: Response<Value, Error>) {
        operation.on(response)
    }
}