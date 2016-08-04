//
//  ProxyTypes.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/29.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - ProxyType
public protocol ProxyType: IntermediateType {
    associatedtype Proxy: BaseIntermediateType

    var proxy: Proxy { get }
}

public extension ProxyType {
    typealias Element = Proxy.Element
    
    var subject: Subject<Proxy.Element> {
        return proxy.subject
    }
    
    func subscribe(observer: Proxy.Element -> Void) -> Disposable {
        return proxy.subscribe(observer)
    }
    
    func subscribed(@noescape by observee: (Proxy.Element -> Void) -> Disposable?) {
        proxy.subscribed(by: observee)
    }
}

// MARK: - NodeProxyType
public protocol NodeProxyType: ProxyType {
    associatedtype Value
    
    var node: Node<Value> { get }
    
    func producer() -> NodeProducer<Value>
}

public extension NodeProxyType {
    typealias Element = Value
    
    var proxy: Node<Value> {
        return node
    }
    
    func producer() -> NodeProducer<Value> {
        return NodeProducer.of(self)
    }
}

// MARK: - StreamProxyType
public protocol StreamProxyType: ProxyType {
    associatedtype Value
    
    var stream: Stream<Value> { get }
    
    func producer() -> StreamProducer<Value>
}

public extension StreamProxyType {
    typealias Element = Signal<Value>
    
    var proxy: Stream<Value> {
        return stream
    }
    
    func producer() -> StreamProducer<Value> {
        return StreamProducer.of(self)
    }
}

// MARK: - OperationProxyType
public protocol OperationProxyType: ProxyType {
    associatedtype Value
    associatedtype Error: ErrorType
    
    var operation: Operation<Value, Error> { get }
    
    func producer() -> OperationProducer<Value, Error>
}

public extension OperationProxyType {
    typealias Element = Response<Value, Error>
    
    var proxy: Operation<Value, Error> {
        return operation
    }
    
    func producer() -> OperationProducer<Value, Error> {
        return OperationProducer.of(self)
    }
}