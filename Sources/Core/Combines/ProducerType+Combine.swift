//
//  ProducerType+Combine.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/26.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public func combine<A, B>(strategy: CombineStrategy, _ a: NodeProducer<A>, _ b: NodeProducer<B>) -> NodeProducer<(A, B)> {
    return NodeProducer {
        makeCombine(a, b, combine, strategy, $0, $1)
    }
}

public func combine<A, B>(strategy: CombineStrategy, _ a: NodeProducer<A>, _ b: StreamProducer<B>) -> StreamProducer<(A, B)> {
    return StreamProducer { 
        makeCombine(a, b, combine, strategy, $0, $1)
    }
}

public func combine<A, B, E>(strategy: CombineStrategy, _ a: NodeProducer<A>, _ b: OperationProducer<B, E>) -> OperationProducer<(A, B), E> {
    return OperationProducer { 
        makeCombine(a, b, combine, strategy, $0, $1)
    }
}

public func combine<A, B>(strategy: CombineStrategy, _ a: StreamProducer<A>, _ b: NodeProducer<B>) -> StreamProducer<(A, B)> {
    return StreamProducer { 
        makeCombine(a, b, combine, strategy, $0, $1)
    }
}

public func combine<A, B>(strategy: CombineStrategy, _ a: StreamProducer<A>, _ b: StreamProducer<B>) -> StreamProducer<(A, B)> {
    return StreamProducer { 
        makeCombine(a, b, combine, strategy, $0, $1)
    }
}

public func combine<A, B, E>(strategy: CombineStrategy, _ a: StreamProducer<A>, _ b: OperationProducer<B, E>) -> OperationProducer<(A, B), E> {
    return OperationProducer { 
        makeCombine(a, b, combine, strategy, $0, $1)
    }
}

public func combine<A, B, E>(strategy: CombineStrategy, _ a: OperationProducer<A, E>, _ b: NodeProducer<B>) -> OperationProducer<(A, B), E> {
    return OperationProducer { 
        makeCombine(a, b, combine, strategy, $0, $1)
    }
}

public func combine<A, B, E>(strategy: CombineStrategy, _ a: OperationProducer<A, E>, _ b: StreamProducer<B>) -> OperationProducer<(A, B), E> {
    return OperationProducer { 
        makeCombine(a, b, combine, strategy, $0, $1)
    }
}

public func combine<A, B, E>(strategy: CombineStrategy, _ a: OperationProducer<A, E>, _ b: OperationProducer<B, E>) -> OperationProducer<(A, B), E> {
    return OperationProducer { 
        makeCombine(a, b, combine, strategy, $0, $1)
    }
}

public extension NodeProducer {
    func combineWith<U>(strategy: CombineStrategy, _ producer: NodeProducer<U>) -> NodeProducer<(Value, U)> {
        return combine(strategy, self, producer)
    }
    
    func combineWith<U>(strategy: CombineStrategy, _ producer: StreamProducer<U>) -> StreamProducer<(Value, U)> {
        return combine(strategy, self, producer)
    }
    
    func combineWith<U, E>(strategy: CombineStrategy, _ producer: OperationProducer<U, E>) -> OperationProducer<(Value, U), E> {
        return combine(strategy, self, producer)
    }
}

public extension StreamProducer {
    func combineWith<U>(strategy: CombineStrategy, _ producer: NodeProducer<U>) -> StreamProducer<(Value, U)> {
        return combine(strategy, self, producer)
    }
    
    func combineWith<U>(strategy: CombineStrategy, _ producer: StreamProducer<U>) -> StreamProducer<(Value, U)> {
        return combine(strategy, self, producer)
    }
    
    func combineWith<U, E>(strategy: CombineStrategy, _ producer: OperationProducer<U, E>) -> OperationProducer<(Value, U), E> {
        return combine(strategy, self, producer)
    }
}

public extension OperationProducer {
    func combineWith<U>(strategy: CombineStrategy, _ producer: NodeProducer<U>) -> OperationProducer<(Value, U), Error> {
        return combine(strategy, self, producer)
    }
    
    func combineWith<U>(strategy: CombineStrategy, _ producer: StreamProducer<U>) -> OperationProducer<(Value, U), Error> {
        return combine(strategy, self, producer)
    }
    
    func combineWith<U>(strategy: CombineStrategy, _ producer: OperationProducer<U, Error>) -> OperationProducer<(Value, U), Error> {
        return combine(strategy, self, producer)
    }
}

private func makeCombine<P1: ProducerType, P2: ProducerType, R: BaseIntermediateType>(producer1: P1, _ producer2: P2, @noescape _ combine: (CombineStrategy, P1.Product, P2.Product) -> R, _ strategy: CombineStrategy, _ observer: R.Element -> Void, _ disposables: CompositeDisposable) {
    
    producer1.startWithProduct { product1 in
        disposables += ScopedDisposable(product1)
        producer2.startWithProduct { product2 in
            disposables += ScopedDisposable(product2)
            disposables += combine(strategy, product1, product2).subscribe(observer)
        }
    }
}