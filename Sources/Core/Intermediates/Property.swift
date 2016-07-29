//
//  Property.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/25.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class Property<T>: PropertyType {
    public typealias Value = T
    public typealias Action = Value -> Void

    var underlayingValue: Value
    
    public var value: Value {
        get {
            return underlayingValue
        }
        
        set {
            // To avoid endless loop of two-way binding.
            if node.subject.lock.tryLock() {
                defer { node.subject.lock.unlock() }
                
                underlayingValue = newValue
                node.subject.on(newValue)
            }
        }
    }
    
    public let node: Node<Value>
    
    public var intermediate: Node<Value> {
        return node
    }
    
    public init(_ name: String, initialValue: Value) {
        node = Node(name)
        underlayingValue = initialValue
    }
    
    public convenience init(_ inititalValue: Value) {
        self.init(String(Property), initialValue: inititalValue)
    }
}

public extension Property {
    func subscribed(@noescape by observee: Action -> Disposable?) {
        let subscription = observee { newValue in
            if self.node.subject.disposed { return }
            
            self.value = newValue
        }
        
        if let subscription = subscription {
            node.subject.disposables.append(subscription)
        }
    }
}