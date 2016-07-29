//
//  Operation.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class Operation<T, E: ErrorType>: BaseIntermediateType, OperationType {
    public typealias Value = T
    public typealias Error = E
    public typealias Response = Reveal.Response<Value, Error>
    public typealias Element = Response
    public typealias Action = Response -> Void
    
    public private(set) var subject: Subject<Response>
    
    public var operation: Operation<Value, Error> {
        return self
    }
    
    public init(_ name: String) {
        subject = Subject(lockName: name)
    }
    
    deinit {
        dispose()
    }
    
    public func dispose() {
        subject.dispose(with: .completed)
    }
}

// MARK: - Source & Sink
public extension Operation {
    func subscribe(observer: Action) -> Disposable {
        return subject.append(observer, owner: self) {
            observer(.completed)
        }
    }
    
    func subscribed(@noescape by observee: Action -> Disposable?) {
        if subject.disposed { return }
        
        var failed = AtomicBool(false)
        var error: Response!
        let subscription = observee { response in
            if self.subject.disposed { return }
            let lock = self.subject.lock
            
            switch response {
            case .failed:
                if failed.swap(true) { return }
                
                error = response
                
                if lock.tryLock() {
                    defer { lock.unlock() }
                    
                    self.subject.dispose(with: response)
                }
            case .next:
                self.subject.lock.lock()
                defer { self.subject.lock.unlock() }
                
                self.subject.on(response)
                
                if failed {
                    self.subject.dispose(with: error)
                }
            case .completed:
                self.subject.synchronizedOn(response)
            }
        }
        
        if let subscription = subscription {
            if subject.disposed {
                subscription.dispose()
            } else {
                subject.disposables.append(subscription)
            }
        }
    }
}