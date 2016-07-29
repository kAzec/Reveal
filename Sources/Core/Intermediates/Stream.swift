//
//  Stream.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/12.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class Stream<T>: BaseIntermediateType, StreamType {
    public typealias Value = T
    public typealias Signal = Reveal.Signal<Value>
    public typealias Element = Signal
    public typealias Action = Signal -> Void
    
    public private(set) var subject: Subject<Signal>
    
    public var stream: Stream<Value> {
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
public extension Stream {
    func subscribe(observer: Action) -> Disposable {
        return subject.append(observer, owner: self) {
            observer(.completed)
        }
    }
    
    func subscribed(@noescape by observee: Action -> Disposable?) {
        let subscription = observee { signal in
            if self.subject.disposed { return }
            
            if case .next = signal {
                self.subject.synchronizedOn(signal)
            } else {
                self.subject.dispose(with: signal)
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

public extension StreamType {
    func promote<Error: ErrorType>(with error: Error.Type) -> Operation<Value, Error> {
        return Operation(observee: apply(Response.makeWithEvent, to: subscribe))
    }
}