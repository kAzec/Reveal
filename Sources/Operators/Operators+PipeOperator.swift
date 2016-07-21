//
//  Operators+PipeOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

infix operator |> { associativity left precedence 140 }

// MARK: - Node
public func |><A, B>(lhs: Node<A>, rhs: ValueOperator<A, B>) -> NodeProxy<A, B> {
    return NodeProxy(source: lhs, transform: rhs.forward)
}

public func |><A, B, C>(lhs: NodeProxy<A, B>, rhs: ValueOperator<B, C>) -> NodeProxy<A, C> {
    return lhs.map(rhs.forward)
}

public func |><A, B>(lhs: NodeProducer<A>, rhs: ValueOperator<A, B>) -> NodeProducer<B> {
    return lhs.map(rhs.forward)
}

// MARK: - Stream
public func |><A, B>(lhs: Stream<A>, rhs: ValueOperator<A, B>) -> StreamProxy<A, B> {
    return StreamProxy(source: lhs, transform: rhs.forwardSignal)
}

public func |><A, B, C>(lhs: StreamProxy<A, B>, rhs: ValueOperator<B, C>) -> StreamProxy<A, C> {
    return lhs.map(rhs.forwardSignal)
}

public func |><A, B>(lhs: StreamProducer<A>, rhs: ValueOperator<A, B>) -> StreamProducer<B> {
    return lhs.map(rhs.forwardSignal)
}

public func |><A, B>(lhs: Stream<A>, rhs: SignalOperator<A, B>) -> StreamProxy<A, B> {
    return StreamProxy(source: lhs, transform: rhs.forward)
}

public func |><A, B, C>(lhs: StreamProxy<A, B>, rhs: SignalOperator<B, C>) -> StreamProxy<A, C> {
    return lhs.map(rhs.forward)
}

public func |><A, B>(lhs: StreamProducer<A>, rhs: SignalOperator<A, B>) -> StreamProducer<B> {
    return lhs.map(rhs.forward)
}

// MARK: - Operation
public func |><A, E, B>(lhs: Operation<A, E>, rhs: ValueOperator<A, B>) -> OperationProxy<A, E, B, E> {
    return OperationProxy(source: lhs, transform: rhs.forwardResponse)
}

public func |><A, E, B, F, C>(lhs: OperationProxy<A, E, B, F>, rhs: ValueOperator<B, C>) -> OperationProxy<A, E, C, F> {
    return lhs.map(rhs.forwardResponse)
}

public func |><A, E, B>(lhs: OperationProducer<A, E>, rhs: ValueOperator<A, B>) -> OperationProducer<B, E> {
    return lhs.map(rhs.forwardResponse)
}

public func |><A, E, B>(lhs: Operation<A, E>, rhs: SignalOperator<A, B>) -> OperationProxy<A, E, B, E> {
    return OperationProxy(source: lhs, transform: rhs.forwardResponse)
}

public func |><A, E, B, F, C>(lhs: OperationProxy<A, E, B, F>, rhs: SignalOperator<B, C>) -> OperationProxy<A, E, C, F> {
    return lhs.map(rhs.forwardResponse)
}

public func |><A, E, B>(lhs: OperationProducer<A, E>, rhs: SignalOperator<A, B>) -> OperationProducer<B, E> {
    return lhs.map(rhs.forwardResponse)
}

public func |><A, E, B, F>(lhs: Operation<A, E>, rhs: ResponseOperator<A, E, B, F>) -> OperationProxy<A, E, B, F> {
    return OperationProxy(source: lhs, transform: rhs.forward)
}

public func |><A, E, B, F, C, G>(lhs: OperationProxy<A, E, B, F>, rhs: ResponseOperator<B, F, C, G>) -> OperationProxy<A, E, C, G> {
    return lhs.map(rhs.forward)
}

public func |><A, E, B, F>(lhs: OperationProducer<A, E>, rhs: ResponseOperator<A, E, B, F>) -> OperationProducer<B, F> {
    return lhs.map(rhs.forward)
}