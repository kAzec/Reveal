//
//  Operation.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class Operation<Value, Error: ErrorType>: BaseIntermediateType, OperationProxyType {
    public typealias Response = Reveal.Response<Value, Error>
    public typealias Action = Response -> Void
    
    public private(set) var subject: Subject<Response>
    
    public var operation: Operation<Value, Error> {
        return self
    }
    
    var failed = AtomicBool(false)
    var failure: Response?
    
    public init(_ name: String) {
        subject = Subject(lockName: name)
    }
    
    deinit {
        dispose()
    }
    
    public func dispose() {
        subject.dispose(with: .completed)
    }
    
    func on(response: Response) {
        if subject.disposed { return }
        let lock = subject.lock
        
        switch response {
        case .failed:
            if failed.swap(true) { return }
            
            failure = response
            
            if lock.tryLock() {
                defer { lock.unlock() }
                subject.dispose(with: response)
            }
        case .next:
            subject.lock.lock()
            defer { subject.lock.unlock() }
            
            subject.on(response)
            
            if failed {
                subject.dispose(with: failure!)
            }
        case .completed:
            subject.synchronized(on: response)
        }
    }
}

// MARK: - Source & Sink
public extension Operation {
    func subscribe(observer: Action) -> Disposable {
        return subject.append(observer, owner: self) {
            $0(.completed)
        }
    }
    
    func subscribed(@noescape by observee: Action -> Disposable?) {
        if subject.disposed { return }
        subject.disposables += observee(on)
    }
}