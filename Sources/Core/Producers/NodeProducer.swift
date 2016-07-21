//
//  NodeProducer.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class NodeProducer<Value>: ProducerType {
    typealias Target = Node<Value>
    
    let anonymousObservee: Target.Action -> Disposable?
    
    init(_ observee: Target.Action -> Disposable?) {
        anonymousObservee = observee
    }
}

public extension Node {
    typealias Producer = NodeProducer<Value>
}

public extension NodeProducer {
    class func of<Source: SourceType where Source.Element == Value>(source source: Source) -> NodeProducer {
        return create(source: source)
    }
    
    class func of<Source: SourceType>(source source: Source, transform: Source.Element -> Value) -> NodeProducer {
        return create(source: source, transform: transform)
    }
    
    class func of(value: Value) -> NodeProducer {
        return create(element: value)
    }
    
    class func of<Sequence: SequenceType where Sequence.Generator.Element == Value>(sequence sequence: Sequence) -> NodeProducer {
        return create(sequence: sequence)
    }
    
    class func never() -> NodeProducer {
        return create{ _ in nil }
    }
}

public extension NodeProducer {
    func startWithNode(@noescape setup: Node<Value> -> Void) {
        return startWithTarget(setup)
    }
    
    func start(observer: Node<Value>.Action? = nil) -> Disposable {
        if let observer = observer {
            return startWithObserver(observer)
        } else {
            return start()
        }
    }
}