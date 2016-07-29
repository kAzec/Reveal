//
//  PropertyType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/28.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - PropertyTypes
public protocol PropertyType: IntermediateOwnerType, NodeType {
    var value: Value { get set }
}

public extension PropertyType {
    typealias Element = Value
    
    func producer() -> NodeProducer<Value> {
        return NodeProducer.of(self).prefix(with: value)
    }
    
    func bind<Property: PropertyType where Property.Value == Value>(to property: Property) -> Disposable {
        property.value = value
        
        return subscribe { [weak property] newValue in
            guard let property = property else { return }
            
            property.value = newValue
        }
    }
}

public extension SourceType {
    func bind<Property: PropertyType where Property.Value == Element>(to property: Property) -> Disposable {
        return subscribe { [weak property] newValue in
            guard let property = property else { return }
            
            property.value = newValue
        }
    }
}

// MARK: - Binding Operator
infix operator ~>> { associativity left precedence 95 }
infix operator ~>< { associativity left precedence 95 }

public func ~>><Source: SourceType, Property: PropertyType where Source.Element == Property.Value>(lhs: Source, rhs: Property) -> Disposable {
    return lhs.bind(to: rhs)
}

public func ~>><P1: PropertyType, P2: PropertyType where P1.Value == P2.Value>(lhs: P1, rhs: P2) -> Disposable {
    return lhs.bind(to: rhs)
}

public func ~><<P1: PropertyType, P2: PropertyType where P1.Value == P2.Value>(lhs: P1, rhs: P2) -> BinaryDisposable {
    return lhs.bind(to: rhs) + rhs.bind(to: lhs)
}