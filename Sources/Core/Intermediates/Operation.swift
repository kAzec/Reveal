//
//  Operation.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

public final class Operation<Value, Error: ErrorType>: IntermediateType {
    public typealias Element = Reveal.Response<Value, Error>
    public typealias Response = Element
    public typealias Action = Response -> Void
    
    public private(set) var repository: Repository<Response>
    
    public init(_ name: String) {
        repository = Repository(lockName: name)
    }
    
    deinit {
        repository.dispose()
    }
}

public extension Operation {
    func subscribe(observer: Action) -> Subscription<Operation> {
        return repository.append(observer, owner: self) {
            observer(.completed)
        }
    }
    
    func subscribeNext(onNext: Value -> Void) -> Subscription<Operation> {
        return repository.append(Observer(next: onNext).action, owner: self)
    }
    
    func subscribeFailed(onFailure: Error -> Void) -> Subscription<Operation> {
        return repository.append(Observer(failure: onFailure).action, owner: self)
    }
    
    func subscribeCompleted(onCompletion: Void -> Void) -> Subscription<Operation> {
        return repository.append(Observer(completion: onCompletion).action, owner: self, failure: onCompletion)
    }
    
    func subscribed(@noescape by observee: Action -> Disposable?) {
        if repository.disposed { return }
        
        var failed = AtomicBool(false)
        var error: Response!
        let subscription = observee { response in
            if self.repository.disposed { return }
            
            switch response {
            case .failed:
                if failed.swap(true) { return }
                
                error = response
                
                if self.repository.lock.tryLock() {
                    
                    self.repository.dispose(with: response)
                    
                    self.repository.lock.unlock()
                }
            case .next:
                self.repository.lock.lock()
                
                self.repository.on(response)
                
                if failed {
                    self.repository.dispose(with: error)
                }
                
                self.repository.lock.unlock()
            case .completed:
                self.repository.synchronizedOn(response)
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