//
//  ProducerType+Flatten.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/4.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - Merge
public func merge<V, S: SourceType where S.Element == Signal<V>>(producer: StreamProducer<S>) -> StreamProducer<V> {
    return StreamProducer {
        makeFlatten(producer, merge, $0, $1)
    }
}

public func merge<V, E, S: SourceType where S.Element == Response<V, E>>(producer: StreamProducer<S>) -> OperationProducer<V, E> {
    return OperationProducer {
        makeFlatten(producer, merge, $0, $1)
    }
}

public func merge<V, E, S: SourceType where S.Element == Signal<V>>(producer: OperationProducer<S, E>) -> OperationProducer<V, E> {
    return OperationProducer {
        makeFlatten(producer, merge, $0, $1)
    }
}

public func merge<V, E, S: SourceType where S.Element == Response<V, E>>(producer: OperationProducer<S, E>) -> OperationProducer<V, E> {
    return OperationProducer {
        makeFlatten(producer, merge, $0, $1)
    }
}

private func makeFlatten<P: ProducerType, R: BaseIntermediateType>(producer: P, _ flatten: P.Product -> R, _ observer: R.Element -> Void, _ disposables: CompositeDisposable) {
    producer.startWithProduct { product in
        disposables += flatten(product).subscribe(observer)
        disposables += ScopedDisposable(product)
    }
}