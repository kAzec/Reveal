//
//  StreamProducer.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public struct StreamProducer<Value>: ProducerType {
    public typealias Product = Stream<Value>
    public typealias Signal = Product.Signal
    
    let producerHandler: (Signal.Action, CompositeDisposable) -> Void
    
    public init(_ producerHandler: (Signal.Action, CompositeDisposable) -> Void) {
        self.producerHandler = producerHandler
    }
    
    public func startWithProduct(@noescape setup: Product -> Void) {
        startWithProduct(setup, producerHandler: producerHandler)
    }
    
    func lift<U>(forwarder: IO<Signal, Reveal.Signal<U>>.Raw) -> StreamProducer<U> {
        return StreamProducer<U>(producerHandler, forwarder)
    }
}

// MARK: - StreamProducer Extensions
public extension StreamProducer {
    func startWithStream(@noescape setup: (Stream<Value>, Disposable) -> Void) {
        return startWithProduct { product in
            setup(product, ScopedDisposable(product))
        }
    }
    
    func first() -> Value? {
        if case .next(let value) = firstElement() {
            return value
        } else {
            return nil
        }
    }
    
    func last() -> Value? {
        return (self |> takeLast()).first()
    }
}

// MARK: - Stream Extension
public extension Stream {
    typealias Producer = StreamProducer<Value>
}