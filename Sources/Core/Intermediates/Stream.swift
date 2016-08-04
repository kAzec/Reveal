//
//  Stream.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/12.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class Stream<Value>: BaseIntermediateType, StreamProxyType {
    public typealias Signal = Reveal.Signal<Value>
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
    
    func on(signal: Signal) {
        if subject.disposed { return }
        
        if case .next = signal {
            subject.synchronized(on: signal)
        } else {
            subject.dispose(with: signal)
        }
    }
}

// MARK: - Source & Sink
public extension Stream {
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

public extension StreamProxyType {
    func promote<Error: ErrorType>(with error: Error.Type) -> Operation<Value, Error> {
        return Operation(observee: apply(Response.makeWithEvent, to: stream.subscribe))
    }
}