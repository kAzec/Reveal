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
public func |><A: NodeType, B>(lhs: A, rhs: NodeOperator<A.Value, B>) -> NodeFault<A.Value, B> {
    return NodeFault(source: lhs.node, forwarder: rhs.forward)
}

public func |><A, B, C>(lhs: NodeFault<A, B>, rhs: NodeOperator<B, C>) -> NodeFault<A, C> {
    return lhs.lift(rhs.forward)
}

public func |><A, B>(lhs: NodeProducer<A>, rhs: NodeOperator<A, B>) -> NodeProducer<B> {
    return lhs.lift(rhs.forward)
}

// MARK: - Stream
// MARK: Using ValueOperator
public func |><A: StreamType, B>(lhs: A, rhs: ValueOperator<A.Value, B>) -> StreamFault<A.Value, B> {
    return StreamFault(source: lhs.stream, forwarder: rhs.forwardSignal)
}

public func |><A, B, C>(lhs: StreamFault<A, B>, rhs: ValueOperator<B, C>) -> StreamFault<A, C> {
    return lhs.lift(rhs.forwardSignal)
}

public func |><A, B>(lhs: StreamProducer<A>, rhs: ValueOperator<A, B>) -> StreamProducer<B> {
    return lhs.lift(rhs.forwardSignal)
}

// MARK: Using StreamOperator
public func |><A: StreamType, B>(lhs: A, rhs: StreamOperator<A.Value, B>) -> StreamFault<A.Value, B> {
    return StreamFault(source: lhs.stream, forwarder: rhs.forward)
}

public func |><A, B, C>(lhs: StreamFault<A, B>, rhs: StreamOperator<B, C>) -> StreamFault<A, C> {
    return lhs.lift(rhs.forward)
}

public func |><A, B>(lhs: StreamProducer<A>, rhs: StreamOperator<A, B>) -> StreamProducer<B> {
    return lhs.lift(rhs.forward)
}

// MARK: - Operation
// MARK: Using ValueOperator
public func |><A: OperationType, B>(lhs: A, rhs: ValueOperator<A.Value, B>) -> OperationFault<A.Value, A.Error, B, A.Error> {
    return OperationFault(source: lhs.operation, forwarder: rhs.forwardResponse)
}

public func |><A, E, B, F, C>(lhs: OperationFault<A, E, B, F>, rhs: ValueOperator<B, C>) -> OperationFault<A, E, C, F> {
    return lhs.lift(rhs.forwardResponse)
}

public func |><A, E, B>(lhs: OperationProducer<A, E>, rhs: ValueOperator<A, B>) -> OperationProducer<B, E> {
    return lhs.lift(rhs.forwardResponse)
}

// MARK: Using SignalOperator
public func |><A: OperationType, B>(lhs: A, rhs: SignalOperator<A.Value, B>) -> OperationFault<A.Value, A.Error, B, A.Error> {
    return OperationFault(source: lhs.operation, forwarder: rhs.forwardResponse)
}

public func |><A, E, B, F, C>(lhs: OperationFault<A, E, B, F>, rhs: SignalOperator<B, C>) -> OperationFault<A, E, C, F> {
    return lhs.lift(rhs.forwardResponse)
}

public func |><A, E, B>(lhs: OperationProducer<A, E>, rhs: SignalOperator<A, B>) -> OperationProducer<B, E> {
    return lhs.lift(rhs.forwardResponse)
}

// MARK: Using ResponseOperator
public func |><A: OperationType, B, F>(lhs: A, rhs: ResponseOperator<A.Value, A.Error, B, F>) -> OperationFault<A.Value, A.Error, B, F> {
    return OperationFault(source: lhs.operation, forwarder: rhs.forward)
}

public func |><A, E, B, F, C, G>(lhs: OperationFault<A, E, B, F>, rhs: ResponseOperator<B, F, C, G>) -> OperationFault<A, E, C, G> {
    return lhs.lift(rhs.forward)
}

public func |><A, E, B, F>(lhs: OperationProducer<A, E>, rhs: ResponseOperator<A, E, B, F>) -> OperationProducer<B, F> {
    return lhs.lift(rhs.forward)
}