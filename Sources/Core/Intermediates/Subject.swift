//
//  Subject.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public struct Subject<Element> {
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
    
    func synchronized(on element: Element) {
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
    
    func append<O: BaseIntermediateType>(action: Action, owner: O, failure onFailure: (Action -> Void)? = nil) -> Disposable {
        if let token = actions.modify({ $0?.append(action) }) {
            return SubscriptionDisposable(source: owner, removalToken: token)
        } else {
            onFailure?(action)
            return BooleanDisposable(disposed: true)
        }
    }
}