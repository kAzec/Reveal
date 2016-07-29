//
//  OperationProducer.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/14.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public struct OperationProducer<Value, Error: ErrorType>: ProducerType {
    public typealias Product = Operation<Value, Error>
    public typealias Response = Product.Response
    
    let producerHandler: (Response.Action, CompositeDisposable) -> Void
    
    public init(_ producerHandler: (Response.Action, CompositeDisposable) -> Void) {
        self.producerHandler = producerHandler
    }
    
    public func startWithProduct(@noescape setup: Product -> Void) {
        startWithProduct(setup, producerHandler: producerHandler)
    }
    
    func lift<U, F>(forwarder: IO<Response, Reveal.Response<U, F>>.Raw) -> OperationProducer<U, F> {
        return OperationProducer<U, F>(producerHandler, forwarder)
    }
}

public extension OperationProducer {
    func startWithOperation(@noescape setup: (Operation<Value, Error>, Disposable) -> Void) {
        return startWithProduct { product in
            setup(product, ScopedDisposable(product))
        }
    }

    func startWithFailed(onFailure: Error -> Void) -> Disposable {
        return start(Response.observer(failure: onFailure))
    }
    
    func startWithResult(onResult: Result<Value, Error> -> Void) -> Disposable {
        return start { response in
            switch response {
            case .next(let value):
                onResult(.success(value))
            case .failed(let error):
                onResult(.failure(error))
            default: break
            }
        }
    }
    
    static func of<Source: SourceType where Source.Element == Signal<Value>>(source: Source) -> OperationProducer {
        return self.init(apply(Response.makeWithEvent, to: source.subscribe))
    }
    
    static func failed(with error: Error) -> OperationProducer {
        return makeOfElement(.failed(error))
    }
    
    static func operate(on operation: Void -> Result<Product.Element.Value, Error>) -> OperationProducer {
        return self.init { observer, _ in
            switch operation() {
            case .success(let result):
                observer(.next(result))
                observer(.completed)
            case .failure(let error):
                observer(.failed(error))
            }
        }
    }
    
    func retry(times: Int) -> OperationProducer {
        return restart(for: times) { $0.failing }
    }
    
    func first() -> Result<Value, Error>? {
        switch firstElement() {
        case .next(let value):
            return .success(value)
        case .failed(let error):
            return .failure(error)
        case .completed:
            return nil
        }
    }
    
    func last() -> Result<Value, Error>? {
        return (self |> takeLast()).first()
    }
}

public extension Operation {
    typealias Producer = OperationProducer<Value, Error>
}