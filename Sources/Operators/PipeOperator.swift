//
//  PipeOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - PipeOperator
infix operator |> { associativity left precedence 100 }

// MARK: - Node
// MARK: Using NodeOperator
public func |><A: NodeProxyType, B>(lhs: A, rhs: NodeOperator<A.Value, B>) -> NodeFault<B> {
    return lhs.lift(rhs.forward)
}

public func |><A, B>(lhs: NodeFault<A>, rhs: NodeOperator<A, B>) -> NodeFault<B> {
    return lhs.lift(rhs.forward)
}

public func |><A, B>(lhs: NodeProducer<A>, rhs: NodeOperator<A, B>) -> NodeProducer<B> {
    return lhs.lift(rhs.forward)
}

// MARK: - Stream
// MARK: Using ValueOperator
public func |><A: StreamProxyType, B>(lhs: A, rhs: ValueOperator<A.Value, B>) -> StreamFault<B> {
    return lhs.lift(rhs.forwardSignal)
}

public func |><A, B>(lhs: StreamFault<A>, rhs: ValueOperator<A, B>) -> StreamFault<B> {
    return lhs.lift(rhs.forwardSignal)
}

public func |><A, B>(lhs: StreamProducer<A>, rhs: ValueOperator<A, B>) -> StreamProducer<B> {
    return lhs.lift(rhs.forwardSignal)
}

// MARK: Using StreamOperator
public func |><A: StreamProxyType, B>(lhs: A, rhs: StreamOperator<A.Value, B>) -> StreamFault<B> {
    return lhs.lift(rhs.forward)
}

public func |><A, B>(lhs: StreamFault<A>, rhs: StreamOperator<A, B>) -> StreamFault<B> {
    return lhs.lift(rhs.forward)
}

public func |><A, B>(lhs: StreamProducer<A>, rhs: StreamOperator<A, B>) -> StreamProducer<B> {
    return lhs.lift(rhs.forward)
}

// MARK: - Operation
// MARK: Using ValueOperator
public func |><A: OperationProxyType, B>(lhs: A, rhs: ValueOperator<A.Value, B>) -> OperationFault<B, A.Error> {
    return lhs.lift(rhs.forwardResponse)
}

public func |><A, E, B>(lhs: OperationFault<A, E>, rhs: ValueOperator<A, B>) -> OperationFault<B, E> {
    return lhs.lift(rhs.forwardResponse)
}

public func |><A, E, B>(lhs: OperationProducer<A, E>, rhs: ValueOperator<A, B>) -> OperationProducer<B, E> {
    return lhs.lift(rhs.forwardResponse)
}

// MARK: Using SignalOperator
public func |><A: OperationProxyType, B>(lhs: A, rhs: SignalOperator<A.Value, B>) -> OperationFault<B, A.Error> {
    return lhs.lift(rhs.forwardResponse)
}

public func |><A, E, B>(lhs: OperationFault<A, E>, rhs: SignalOperator<A, B>) -> OperationFault<B, E> {
    return lhs.lift(rhs.forwardResponse)
}

public func |><A, E, B>(lhs: OperationProducer<A, E>, rhs: SignalOperator<A, B>) -> OperationProducer<B, E> {
    return lhs.lift(rhs.forwardResponse)
}

// MARK: Using ResponseOperator
public func |><A: OperationProxyType, B, F>(lhs: A, rhs: ResponseOperator<A.Value, A.Error, B, F>) -> OperationFault<B, F> {
    return lhs.lift(rhs.forward)
}

public func |><A, E, B, F>(lhs: OperationFault<A, E>, rhs: ResponseOperator<A, E, B, F>) -> OperationFault<B, F> {
    return lhs.lift(rhs.forward)
}

public func |><A, E, B, F>(lhs: OperationProducer<A, E>, rhs: ResponseOperator<A, E, B, F>) -> OperationProducer<B, F> {
    return lhs.lift(rhs.forward)
}