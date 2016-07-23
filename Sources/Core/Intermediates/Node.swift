//
//  Node.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class Node<Value>: IntermediateType {
    public typealias Element = Value
    public typealias Action = Element -> Void
    
    public private(set) var repository: Repository<Value>
    
    public init(_ name: String) {
        repository = Repository(lockName: name)
    }
    
    deinit {
        repository.dispose()
    }
}

public extension Node {
    func subscribe(observer: Observer.Action) -> Subscription<Node> {
        return repository.append(observer, owner: self)
    }
    
    func subscribed(@noescape by observee: Action -> Disposable?) {
        let subscription = observee { value in
            guard !self.repository.disposed else { return }
            
            self.repository.synchronizedOn(value)
        }
            
        if let subscription = subscription {
            repository.disposables.append(subscription)
        }
    }
    
    func dispose() {
        repository.dispose()
    }
}