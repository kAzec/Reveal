//
//  KeyValueProperty.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/26.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class KeyValueProperty<Value>: NSObject, PropertyType {
    private let object: NSObject
    private let keyPath: String
    private var context: Int32 = 0
    private let transform: (AnyObject -> Value)?
    
    public let stream: Stream<Value>
    
    public var value: Value {
        get {
            return transform(object.valueForKeyPath(keyPath) ?? kCFNull)
        }
        
        set {
            on(.next(newValue), runtime: false)
        }
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
    
    public init(object: NSObject, keyPath: String, transform: (AnyObject -> Value)? = nil) {
        self.object = object
        self.keyPath = keyPath
        self.transform = transform
        stream = Stream("\(keyPath) of \(object)")
        
        super.init()
        
        object.addObserver(self, forKeyPath: keyPath, options: .New, context: &context)
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard context == &self.context else { return }
        guard let rawNewValue = change?[NSKeyValueChangeNewKey] else { return }
        on(.next(transform(rawNewValue)), runtime: true)
    }
    
    public func subscribed(@noescape by observee: Signal<Value>.Action -> Disposable?) {
        if stream.subject.disposed { return }
        
        stream.subject.disposables += observee { signal in
            self.on(signal, runtime: false)
        }
    }
    
    func transform(object: AnyObject) -> Value {
        if let transform = transform {
            return transform(object)
        } else {
            return object as! Value
        }
    }
    
    func on(signal: Signal<Value>, runtime: Bool) {
        if stream.subject.disposed { return }

        // To avoid endless loop of two-way binding.
        if case .next(let newValue) = signal where stream.subject.lock.tryLock() {
            defer { stream.subject.lock.unlock() }
            
            if !runtime {
                object.setValue(newValue as? AnyObject, forKeyPath: keyPath)
            }
            
            stream.subject.on(signal)
        } else {
            stream.subject.disposables.prune()
        }
    }
}