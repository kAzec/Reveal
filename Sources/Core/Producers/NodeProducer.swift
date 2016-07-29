//
//  NodeProducer.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public struct NodeProducer<Value>: ProducerType {
    public typealias Product = Node<Value>
    
    let producerHandler: (Node<Value>.Action, CompositeDisposable) -> Void
    
    public init(_ producerHandler: (Node<Value>.Action, CompositeDisposable) -> Void) {
        self.producerHandler = producerHandler
    }
    
    public func startWithProduct(@noescape setup: Product -> Void) {
        startWithProduct(setup, producerHandler: producerHandler)
    }
    
    func lift<U>(forwarder: IO<Value, U>.Raw) -> NodeProducer<U> {
        return NodeProducer<U>(producerHandler, forwarder)
    }
}

// MARK: - NodeProducer Extensions
public extension NodeProducer {
    static func of(value: Value) -> NodeProducer {
        return makeOfElement(value)
    }
    
    static func of<Sequence: SequenceType where Sequence.Generator.Element == Value>(sequence sequence: Sequence) -> NodeProducer {
        return makeOfElements(first: nil, middle: sequence, last: nil)
    }
    
    static func of(values first: Value, _ rest: Value...) -> NodeProducer {
        return makeOfElements(first: first, middle: rest, last: nil)
    }
    
    func startWithNode(@noescape setup: (Node<Value>, Disposable) -> Void) {
        return startWithProduct { product in
            setup(product, ScopedDisposable(product))
        }
    }
    
    func first() -> Value {
        return firstElement()
    }
}

// MARK: - Node Extension
public extension Node {
    typealias Producer = NodeProducer<Value>
}