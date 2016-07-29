//
//  Operator+Customization.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/23.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public func compose<A, B, C>(left: ValueOperator<A, B>, _ right: ValueOperator<B, C>) -> ValueOperator<A, C> {
    return ComposeNode(left: left, right: right)
}

public func +<A, B, C>(lhs: ValueOperator<A, B>, rhs: ValueOperator<B, C>) -> ValueOperator<A, C> {
    return compose(lhs, rhs)
}

public func compose<A, B, C>(left: SignalOperator<A, B>, _ right: SignalOperator<B, C>) -> SignalOperator<A, C> {
    return ComposeStream(left: left, right: right)
}

public func +<A, B, C>(lhs: SignalOperator<A, B>, rhs: SignalOperator<B, C>) -> SignalOperator<A, C> {
    return compose(lhs, rhs)
}

public func compose<A, E, B, F, C, G>(left: ResponseOperator<A, E, B, F>, _ right: ResponseOperator<B, F, C, G>) -> ResponseOperator<A, E, C, G> {
    return ComposeResponse(left: left, right: right)
}

public func +<A, E, B, F, C, G>(lhs: ResponseOperator<A, E, B, F>, rhs: ResponseOperator<B, F, C, G>) -> ResponseOperator<A, E, C, G> {
    return compose(lhs, rhs)
}

public func customize<I, O>(value forwarder: (I, (O -> Void)) -> Void) -> ValueOperator<I, O> {
    return CustomizeValue(forwarder)
}

public func customize<I, O>(signal forwarder: (Signal<I>, Signal<O>.Action) -> Void) -> SignalOperator<I, O> {
    return CustomizeSignal(forwarder)
}

public func customize<I, E, O, F>(response forwarder: (Response<I, E>, Response<O, F>.Action) -> Void) -> ResponseOperator<I, E, O, F> {
    return CustomizeResponse(forwarder)
}