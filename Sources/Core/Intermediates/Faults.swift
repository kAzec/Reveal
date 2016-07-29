//
//  Faults.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/28.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public class Fault<Source: BaseIntermediateType, Result: BaseIntermediateType>: FaultType {
    public var fault: Bool {
        return lazy == nil
    }
    
    public var intermediate: Result {
        return fire().result
    }
    
    let source: Source
    let forwarder: IO<Source.Element, Result.Element>.Raw
    var lazy: (result: Result, subscription: Disposable)?
    
    public required init(source: Source, forwarder: (Result.Element -> Void) -> (Source.Element -> Void)) {
        self.source = source
        self.forwarder = forwarder
    }
    
    func fire() -> (result: Result, subscription: Disposable) {
        if let fired = self.lazy {
            return fired
        }
        
        let result = Result()
        
        var subscription: Disposable!
        
        result.subscribed { observer in
            subscription = source.subscribe(forwarder(observer))
            
            return subscription
        }
        
        let fired = (result, subscription!)
        self.lazy = fired
        return fired
    }
    
    func lift<F: FaultType where F.Source == Source>(forwarder: IO<Result.Element, F.Result.Element>.Raw) -> F {
        return F(source: source, forwarder: compose(forwarder, self.forwarder))
    }
}

public final class NodeFault<I, O>: Fault<Node<I>, Node<O>>, NodeType {
    public var node: Node<O> {
        return fire().result
    }
    
    public required init(source: Node<I>, forwarder: (O -> Void) -> (I -> Void)) {
        super.init(source: source, forwarder: forwarder)
    }
}

public final class StreamFault<I, O>: Fault<Stream<I>, Stream<O>>, StreamType {
    public var stream: Stream<O> {
        return fire().result
    }

    public required init(source: Stream<I>, forwarder: Signal<O>.Action -> Signal<I>.Action) {
        super.init(source: source, forwarder: forwarder)
    }
}

public final class OperationFault<I, E: ErrorType, O, F: ErrorType>: Fault<Operation<I, E>, Operation<O, F>>, OperationType {
    public var operation: Operation<O, F> {
        return fire().result
    }

    public required init(source: Operation<I, E>, forwarder: Operation<O, F>.Action -> Operation<I, E>.Action) {
        super.init(source: source, forwarder: forwarder)
    }
}