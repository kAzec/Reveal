//
//  Repository.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

public struct Repository<Element> {
    typealias Action = Element -> Void
    
    let lock = NSLock()
    let actions = Atomic<Bag<Action>?>(Bag())
    var disposed = AtomicBool(false)
    let disposables = CompositeDisposable()
    
    init(lockName: String) {
        lock.name = lockName
    }
    
    func on(element: Element) {
        for action in actions.value! {
            action(element)
        }
    }
    
    func synchronizedOn(element: Element) {
        lock.lock()
        defer { lock.unlock() }
        
        for action in actions.value! {
            action(element)
        }
    }
    
    mutating func dispose() -> Bag<Action>? {
        if disposed.swap(true) { return nil }
        
        let actions = self.actions.swap(nil)
        disposables.dispose()
        return actions
    }
    
    mutating func dispose(with element: Element) {
        if let actions = dispose() {
            lock.lock()
            defer { lock.unlock() }
            
            for action in actions {
                action(element)
            }
        }
    }
    
    mutating func append<O: IntermediateType>(action: Action, owner: O, failure onFailure: (Void -> Void)? = nil) -> Subscription<O> {
        if let token = actions.modify({ $0?.append(action) }) {
            return Subscription(source: owner) { owner in
                owner.repository.actions.modify{ $0?.remove(for: token) }
            }
        } else {
            onFailure?()
            return Subscription()
        }
    }
}

public extension IntermediateType {
    var disposed: Bool {
        return repository.disposed.boolValue
    }
}