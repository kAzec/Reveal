//
//  StreamProducer.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class StreamProducer<Value>: ProducerType {
    typealias Target = Stream<Value>
    public typealias Signal = Target.Signal
    
    let anonymousObservee: Target.Action -> Disposable?
    
    init(_ observee: Target.Action -> Disposable?) {
        anonymousObservee = observee
    }
}

public extension Stream {
    typealias Producer = StreamProducer<Value>
}

public extension StreamProducer {
    class func of<Source: SourceType where Source.Element == Signal>(source source: Source) -> StreamProducer {
        return create(source: source)
    }
    
    class func of<Source: SourceType>(source source: Source, transform: Source.Element -> Signal) -> StreamProducer {
        return create(source: source, transform: transform)
    }
    
    class func of(value: Value) -> StreamProducer {
        return create { observer in
            observer(.next(value))
            observer(.completed)
            return nil
        }
    }
    
    class func of<Sequence: SequenceType where Sequence.Generator.Element == Value>(sequence sequence: Sequence) -> StreamProducer {
        return create { observer in
            for value in sequence {
                observer(.next(value))
            }
            
            observer(.completed)
            return nil
        }
    }
    
    class func of(values first: Value, _ rest: Value...) -> StreamProducer {
        return create { observer in
            observer(.next(first))
            for value in rest {
                observer(.next(value))
            }
            
            observer(.completed)
            return nil
        }
    }
    
    class func empty() -> StreamProducer {
        return create(element: .completed)
    }
    
    class func never() -> StreamProducer {
        return create{ _ in nil }
    }
}

public extension StreamProducer {
    func startWithStream(@noescape setup: Stream<Value> -> Void) {
        return startWithTarget(setup)
    }
    
    func start(observer: Stream<Value>.Action? = nil) -> Disposable {
        if let observer = observer {
            return startWithObserver(observer)
        } else {
            return start()
        }
    }
    
    func startWithNext(onNext: Value -> Void) -> Disposable {
        return start(Stream<Value>.Observer(next: onNext).action)
    }
    
    func startWithCompleted(onCompletion: Void -> Void) -> Disposable {
        return start(Stream<Value>.Observer(completion: onCompletion).action)
    }
}