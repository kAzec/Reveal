//
//  Property.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/25.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class Property<Value>: PropertyType {
    var underlayingValue: Value
    
    public var value: Value {
        get {
            return underlayingValue
        }
        
        set {
            on(.next(newValue))
        }
    }
    
    public let stream: Stream<Value>
    
    public init(_ name: String, initialValue: Value) {
        stream = Stream(name)
        underlayingValue = initialValue
    }
    
    public convenience init(_ inititalValue: Value) {
        self.init(String(Property), initialValue: inititalValue)
    }
    
    deinit {
        stream.dispose()
    }
    
    public func producer() -> StreamProducer<Value> {
        return StreamProducer { [weak self] observer, disposable in
            if let weakSelf = self {
                observer(.next(weakSelf.value))
                disposable += weakSelf.subscribe(observer)
            } else {
                observer(.completed)
            }
        }
    }
    
    public func subscribed(@noescape by observee: Signal<Value>.Action -> Disposable?) {
        if stream.subject.disposed { return }
        stream.subject.disposables += observee(on)
    }
    
    func on(signal: Signal<Value>) {
        if stream.subject.disposed { return }
        
        // To avoid endless loop of two-way binding.
        if case .next(let newValue) = signal where stream.subject.lock.tryLock() {
            defer { stream.subject.lock.unlock() }
            underlayingValue = newValue
            stream.subject.on(signal)
        } else {
            stream.subject.disposables.prune()
        }
    }
}