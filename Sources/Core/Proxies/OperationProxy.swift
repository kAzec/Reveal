//
//  OperationProxy.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class OperationProxy<T, E: ErrorType, U, F: ErrorType>: ProxyType {
    typealias Transform = IO<Response<T, E>, Response<U, F>>.Raw
    
    let source: Operation<T, E>
    let transform: Transform
    var materialized: (Operation<U, F>, Subscription<Operation<T, E>>)?
    
    init(source: Operation<T, E>, transform: Transform) {
        self.source = source
        self.transform = transform
    }
    
    public func materialize() -> (operation: Operation<U, F>, subscription: Subscription<Operation<T, E>>) {
        return _materialize()
    }
    
    public func operation() -> Operation<U, F> {
        return _materialize().0
    }
    
    public func subscribe(observer: Operation<U, F>.Action) -> Relationship<Operation<T, E>, Operation<U, F>> {
        return _subscribe(observer)
    }
}