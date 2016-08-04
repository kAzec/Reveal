//
//  SourceType+Combine.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/26.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - Combine Strategy
public enum CombineStrategy {
    case zip, latest
}

// MARK: - Combine Functions

// MARK: NodeProxyType
public func combine<A: NodeProxyType, B: NodeProxyType>(strategy: CombineStrategy, _ a: A, _ b: B) -> Node<(A.Value, B.Value)> {
    switch strategy {
    case .zip:
        return combine(ZipState(), a, b)
    case .latest:
        return combine(CombineLatestState(), a, b)
    }
}

public func combine<A: NodeProxyType, B: StreamProxyType>(strategy: CombineStrategy, _ a: A, _ b: B) -> Stream<(A.Value, B.Value)> {
    return combine(strategy, a.promote(), b)
}

public func combine<A: NodeProxyType, B: OperationProxyType>(strategy: CombineStrategy, _ a: A, _ b: B) -> Operation<(A.Value, B.Value), B.Error> {
    return combine(strategy, a.promote(with: B.Error.self), b)
}

// MARK: StreamProxyType
public func combine<A: StreamProxyType, B: NodeProxyType>(strategy: CombineStrategy, _ a: A, _ b: B) -> Stream<(A.Value, B.Value)> {
    return combine(strategy, a, b.promote())
}

public func combine<A: StreamProxyType, B: StreamProxyType>(strategy: CombineStrategy, _ a: A, _ b: B) -> Stream<(A.Value, B.Value)> {
    switch strategy {
    case .zip:
        return combine(ZipState(), a, b)
    case .latest:
        return combine(CombineLatestState(), a, b)
    }
}

public func combine<A: StreamProxyType, B: OperationProxyType>(strategy: CombineStrategy, _ a: A, _ b: B) -> Operation<(A.Value, B.Value), B.Error> {
    return combine(strategy, a.promote(with: B.Error.self), b)
}

// MARK: OperationProxyType
public func combine<A: OperationProxyType, B: NodeProxyType>(strategy: CombineStrategy, _ a: A, _ b: B) -> Operation<(A.Value, B.Value), A.Error> {
    return combine(strategy, a, b.promote(with: A.Error.self))
}

public func combine<A: OperationProxyType, B: StreamProxyType>(strategy: CombineStrategy, _ a: A, _ b: B) -> Operation<(A.Value, B.Value), A.Error> {
    return combine(strategy, a, b.promote(with: A.Error.self))
}

public func combine<A: OperationProxyType, B: OperationProxyType where A.Error == B.Error>(strategy: CombineStrategy, _ a: A, _ b: B) -> Operation<(A.Value, B.Value), A.Error> {
    switch strategy {
    case .zip:
        return combine(ZipState(), a, b)
    case .latest:
        return combine(CombineLatestState(), a, b)
    }
}

// MARK: - Combine Extensions

// MARK: NodeProxyType Extensions
public extension NodeProxyType {
    func combineWith<N: NodeProxyType>(strategy: CombineStrategy, _ node: N) -> Node<(Value, N.Value)> {
        return combine(strategy, self, node)
    }
    
    func combineWith<S: StreamProxyType>(strategy: CombineStrategy, _ stream: S) -> Stream<(Value, S.Value)> {
        return combine(strategy, self.promote(), stream)
    }
    
    func combineWith<O: OperationProxyType>(strategy: CombineStrategy, _ operation: O) -> Operation<(Value, O.Value), O.Error> {
        return combine(strategy, self.promote(with: O.Error.self), operation)
    }
}

// MARK: StreamProxyType Extensions
public extension StreamProxyType {
    func combineWith<N: NodeProxyType>(strategy: CombineStrategy, _ node: N) -> Stream<(Value, N.Value)> {
        return combine(strategy, self, node.promote())
    }
    
    func combineWith<S: StreamProxyType>(strategy: CombineStrategy, _ stream: S) -> Stream<(Value, S.Value)> {
        return combine(strategy, self, stream)
    }
    
    func combineWith<O: OperationProxyType>(strategy: CombineStrategy, _ operation: O) -> Operation<(Value, O.Value), O.Error> {
        return combine(strategy, self.promote(with: O.Error.self), operation)
    }
}

// MARK: OperationProxyType Extensions
public extension OperationProxyType {
    func combineWith<N: NodeProxyType>(strategy: CombineStrategy, _ node: N) -> Operation<(Value, N.Value), Error> {
        return combine(strategy, self, node.promote(with: Error.self))
    }
    
    func combineWith<S: StreamProxyType>(strategy: CombineStrategy, _ stream: S) -> Operation<(Value, S.Value), Error> {
        return combine(strategy, self, stream.promote(with: Error.self))
    }
    
    func combineWith<O: OperationProxyType where O.Error == Error>(strategy: CombineStrategy, _ operation: O) -> Operation<(Value, O.Value), Error> {
        return combine(strategy, self, operation)
    }
}

// MARK: - Privates
private func combine<State: CombineStateType, A: NodeProxyType, B: NodeProxyType where State.Left == A.Value, State.Right == B.Value>(state: State, _ a: A, _ b: B) -> Node<(A.Value, B.Value)> {
    return Node(String(state)) { observer in
        var flush = CombineSink<State, NotAnError>(
            state:      state,
            next:       { observer($0.0, $0.1) },
            completion: nil,
            failure:    nil
        )
        
        return a.subscribe { value in
            flush.on(.leftValue(value))
        } + b.subscribe { value in
            flush.on(.rightValue(value))
        }
    }
}

private func combine<State: CombineStateType, A: StreamProxyType, B: StreamProxyType where State.Left == A.Value, State.Right == B.Value>(state: State, _ a: A, _ b: B) -> Stream<(A.Value, B.Value)> {
    return Stream(String(state)) { observer in
        var flush = CombineSink<State, NotAnError>(
            state:      state,
            next:       { observer(.next($0)) },
            completion: { observer(.completed) },
            failure:    nil
        )
        
        return a.subscribe { signal in
            if case .next(let value) = signal {
                flush.on(.leftValue(value))
            } else {
                flush.on(.leftCompleted)
            }
        } + b.subscribe { signal in
            if case .next(let value) = signal {
                flush.on(.rightValue(value))
            } else {
                flush.on(.rightCompleted)
            }
        }
    }
}

private func combine<State: CombineStateType, A: OperationProxyType, B: OperationProxyType where A.Error == B.Error, State.Left == A.Value, State.Right == B.Value>(state: State, _ a: A, _ b: B) -> Operation<(A.Value, B.Value), A.Error> {
    return Operation(String(state)) { observer in
        var flush = CombineSink<State, A.Error>(
            state:      state,
            next:       { observer(.next($0)) },
            completion: { observer(.completed) },
            failure:    { observer(.failed($0)) }
        )
        
        return a.subscribe { response in
            switch response {
            case .next(let value):
                flush.on(.leftValue(value))
            case .failed(let error):
                flush.on(.failed(error))
            case .completed:
                flush.on(.leftCompleted)
            }
        } + b.subscribe { response in
            switch response {
            case .next(let value):
                flush.on(.rightValue(value))
            case .failed(let error):
                flush.on(.failed(error))
            case .completed:
                flush.on(.rightCompleted)
            }
        }
    }
}

private protocol CombineStateType: CustomStringConvertible {
    associatedtype Left
    associatedtype Right
    
    var completed: (left: Bool, right: Bool) { get set }
    var finished: Bool { get }
    
    mutating func receive(left: Left) -> (Left, Right)?
    mutating func receive(right: Right) -> (Left, Right)?
}

private struct ZipState<Left, Right>: CombineStateType {
    typealias Pair = (Left, Right)
    
    var values: (left: [Left], right: [Right]) = ([], [])
    var completed: (left: Bool, right: Bool) = (false, false)
    
    var finished: Bool {
        return (completed.left && values.left.isEmpty) || (completed.right && values.right.isEmpty)
    }
    
    init() {  }
    
    mutating func pair() -> Pair {
        return (values.left.removeFirst(), values.right.removeFirst())
    }
    
    mutating func receive(left: Left) -> Pair? {
        if values.right.isEmpty {
            values.left.append(left)
            return nil
        }
        
        if values.left.isEmpty {
            return (left, values.right.removeFirst())
        } else {
            return pair()
        }
    }
    
    mutating func receive(right: Right) -> Pair? {
        if values.left.isEmpty {
            values.right.append(right)
            return nil
        }
        
        if values.right.isEmpty {
            return (values.left.removeFirst(), right)
        } else {
            return pair()
        }
    }
    
    var description: String {
        return "Zip<\(String(Left)), \(String(Right))>"
    }
}

private struct CombineLatestState<Left, Right>: CombineStateType {
    typealias Pair = (Left, Right)
    
    var latest: (left: Left?, right: Right?)
    var completed: (left: Bool, right: Bool) = (false, false)
    
    var finished: Bool {
        return completed.left && completed.right
    }
    
    init() {  }
    
    mutating func receive(left: Left) -> Pair? {
        latest.left = left
        if let right = latest.right {
            return (left, right)
        } else { return nil }
    }
    
    mutating func receive(right: Right) -> Pair? {
        latest.right = right
        if let left = latest.left {
            return (left, right)
        } else { return nil }
    }
    
    var description: String {
        return "CombineLatest<\(String(Left)), \(String(Right))>"
    }
}

private enum CombineEvent<Left, Right, Error: ErrorType> {
    case leftValue(Left)
    case rightValue(Right)
    case leftCompleted
    case rightCompleted
    case failed(Error)
}

enum NotAnError: ErrorType {  }

private struct CombineSink<State: CombineStateType, Error: ErrorType> {
    typealias Left = State.Left
    typealias Right = State.Right
    
    let atomicState: Atomic<State>
    
    let onNext: (Left, Right) -> Void
    let onCompletion: (Void -> Void)!
    let onFailure: (Error -> Void)!
    
    init(state: State, next: (Left, Right) -> Void, completion: (Void -> Void)?, failure: (Error -> Void)?) {
        atomicState = Atomic(state)
        onNext = next
        onCompletion = completion
        onFailure = failure
    }
    
    mutating func on(event: CombineEvent<Left, Right, Error>) {
        var pair: (Left, Right)?
        var finished = false
        var failure: Error?
        
        atomicState.modify { state in
            switch event {
            case .leftValue(let left):
                pair = state.receive(left)
            case .rightValue(let right):
                pair = state.receive(right)
            case .leftCompleted:
                state.completed.left = true
            case .rightCompleted:
                state.completed.right = true
            case .failed(let error):
                failure = error
            }
            
            finished = state.finished
        }
        
        if let pair = pair {
            onNext(pair.0, pair.1)
        }
        
        if finished {
            onCompletion()
        }
        
        if let failure = failure {
            onFailure(failure)
        }
    }
}