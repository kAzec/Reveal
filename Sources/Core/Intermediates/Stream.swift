//
//  Stream.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/12.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class Stream<Value>: IntermediateType {
    public typealias Element = Reveal.Signal<Value>
    public typealias Signal = Element
    public typealias Action = Signal -> Void
    
    public private(set) var repository: Repository<Signal>
    
    public init(_ name: String) {
        repository = Repository(lockName: name)
    }
    
    deinit {
        repository.dispose()
    }
}

public extension Stream {
    func subscribe(observer: Action) -> Subscription<Stream> {
        return repository.append(observer, owner: self) {
            observer(.completed)
        }
    }
    
    func subscribeNext(observer: Value -> Void) -> Subscription<Stream> {
        return repository.append(Observer(next: observer).action, owner: self)
    }
    
    func subscribeCompleted(observer: Void -> Void) -> Subscription<Stream> {
        return repository.append(Observer(completion: observer).action, owner: self, failure: observer)
    }
    
    func subscribed(@noescape by observee: Action -> Disposable?) {
        let subscription = observee { signal in
            if self.repository.disposed { return }
            
            if case .next = signal {
                self.repository.synchronizedOn(signal)
            } else {
                self.repository.dispose(with: signal)
            }
        }
        
        if let subscription = subscription {
            if repository.disposed {
                subscription.dispose()
            } else {
                repository.disposables.append(subscription)
            }
        }

    }
    
    func dispose() {
        repository.dispose()
    }
}