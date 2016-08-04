//
//  Node.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class Node<Value>: BaseIntermediateType, NodeProxyType {
    public typealias Action = Value -> Void
    
    public private(set) var subject: Subject<Value>
    
    public var node: Node<Value> {
        return self
    }
    
    public init(_ name: String) {
        subject = Subject(lockName: name)
    }
    
    deinit {
        dispose()
    }
    
    public func dispose() {
        subject.dispose()
    }
    
    func on(value: Value) {
        if subject.disposed { return }
        
        subject.synchronized(on: value)
    }
}

// MARK: - Source & Sink
public extension Node {
    func subscribe(observer: Action) -> Disposable {
        return subject.append(observer, owner: self)
    }
    
    func subscribed(@noescape by observee: Action -> Disposable?) {
        if subject.disposed { return }
        subject.disposables += observee(on)
    }
}

public extension NodeProxyType {
    func promote() -> Stream<Value> {
        return Stream(observee: apply(Signal.makeNext, to: node.subscribe))
    }
    
    func promote<Error: ErrorType>(with error: Error.Type) -> Operation<Value, Error> {
        return Operation(observee: apply(Response.makeNext, to: node.subscribe))
    }
}