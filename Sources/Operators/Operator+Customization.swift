//
//  Operator+Customization.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/23.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public func compose<A, B, C>(operator1: ValueOperator<A, B>, operator2: ValueOperator<B, C>) -> ValueOperator<A, C> {
    return Compose(operator1: operator1, operator2: operator2)
}

public func +<A, B, C>(rhs: ValueOperator<A, B>, lhs: ValueOperator<B, C>) -> ValueOperator<A, C> {
    return Compose(operator1: rhs, operator2: lhs)
}

public func customize<I, O>(value forwarder: (I, (O -> Void)) -> Void) -> ValueOperator<I, O> {
    return CustomizeValue(forwarder)
}

public func customize<I, O>(signal forwarder: (Signal<I>, Signal<O> -> Void) -> Void) -> SignalOperator<I, O> {
    return CustomizeSignal(forwarder)
}

public func customize<I, E, O, F>(response forwarder: (Response<I, E>, Response<O, F> -> Void) -> Void) -> ResponseOperator<I, E, O, F> {
    return CustomizeResponse(forwarder)
}