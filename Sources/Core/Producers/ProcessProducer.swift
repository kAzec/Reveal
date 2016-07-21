//
//  OperationProducer.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/14.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class OperationProducer<Value, Error: ErrorType>: ProducerType {
    typealias Target = Operation<Value, Error>
    public typealias Response = Target.Response
    
    let anonymousObservee: Target.Action -> Disposable?
    
    init(_ observee: Target.Action -> Disposable?) {
        anonymousObservee = observee
    }
}

public extension Operation {
    typealias Producer = OperationProducer<Value, Error>
}

public extension OperationProducer {
    class func of<Source: SourceType where Source.Element == Response>(source source: Source) -> OperationProducer {
        return create(source: source)
    }
    
    class func of<Source: SourceType>(source source: Source, transform: Source.Element -> Response) -> OperationProducer {
        return create(source: source, transform: transform)
    }
    
    class func of(value: Value) -> OperationProducer {
        return create { observer in
            observer(.next(value))
            observer(.completed)
            return nil
        }
    }
    
    class func of<Sequence: SequenceType where Sequence.Generator.Element == Value>(sequence sequence: Sequence) -> OperationProducer {
        return create { observer in
            for value in sequence {
                observer(.next(value))
            }
            
            observer(.completed)
            return nil
        }
    }
    
    class func of(first: Value, _ rest: Value...) -> OperationProducer {
        return create { observer in
            observer(.next(first))
            for value in rest {
                observer(.next(value))
            }
            
            observer(.completed)
            return nil
        }
    }
    
    class func failed(with error: Error) -> OperationProducer {
        return create(element: .failed(error))
    }
    
    class func of(operation operation: Void -> Result<Value, Error>) -> OperationProducer {
        return create{ observer in
            switch operation() {
            case .success(let result):
                observer(.next(result))
                observer(.completed)
            case .failure(let error):
                observer(.failed(error))
            }
            
            return nil
        }
    }
    
    class func empty() -> OperationProducer {
        return create(element: .completed)
    }
    
    class func never() -> OperationProducer {
        return create{ _ in nil }
    }
}

public extension OperationProducer {
    func startWithOperation(@noescape setup: Operation<Value, Error> -> Void) {
        return startWithTarget(setup)
    }
    
    func start(observer: Operation<Value, Error>.Action? = nil) -> Disposable {
        if let observer = observer {
            return startWithObserver(observer)
        } else {
            return start()
        }
    }
    
    func startWithNext(onNext: Value -> Void) -> Disposable {
        return start(Operation<Value, Error>.Observer(next: onNext).action)
    }
    
    func startWithFailed(onFailure: Error -> Void) -> Disposable {
        return start(Operation<Value, Error>.Observer(failure: onFailure).action)
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
    
    func startWithCompleted(onCompletion: Void -> Void) -> Disposable {
        return start(Operation<Value, Error>.Observer(completion: onCompletion).action)
    }
}