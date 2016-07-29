//
//  Node.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class Node<T>: BaseIntermediateType, NodeType {
    public typealias Value = T
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
}

// MARK: - Source & Sink
public extension Node {
    func subscribe(observer: Action) -> Disposable {
        return subject.append(observer, owner: self)
    }
    
    func subscribed(@noescape by observee: Action -> Disposable?) {
        let subscription = observee { value in
            if self.subject.disposed { return }
            
            self.subject.synchronizedOn(value)
        }
            
        if let subscription = subscription {
            subject.disposables.append(subscription)
        }
    }
}

public extension NodeType {
    func promote() -> Stream<Value> {
        return Stream(observee: apply(Signal.makeNext, to: subscribe))
    }
    
    func promote<Error: ErrorType>(with error: Error.Type) -> Operation<Value, Error> {
        return Operation(observee: apply(Response.makeNext, to: subscribe))
    }
}