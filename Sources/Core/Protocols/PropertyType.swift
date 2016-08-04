//
//  PropertyType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/28.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - PropertyTypes
public protocol PropertyType: StreamProxyType, Disposable {
    var value: Value { get set }
}

public extension PropertyType {
    func dispose() {
        stream.dispose()
    }
    
    var disposed: Bool {
        return stream.subject.disposed.boolValue
    }
}

// MARK: - Binding Extensions
public extension SourceType {
    func bind<Property: PropertyType>(to property: Property, transform: Element -> Property.Value?) -> Disposable {
        return bind(to: property, transform: transform, isFailureTermination: false)
    }
    
    func bind<Property: PropertyType where Property.Value == Element>(to property: Property) -> Disposable {
        return bind(to: property, transform: id, isFailureTermination: false)
    }
}

public extension SourceType where Element: EventType {
    func bind<Property: PropertyType where Property.Value == Element.Value>(to property: Property) -> Disposable {
        return bind(to: property, transform: { $0.next }, isFailureTermination: true)
    }
}

public extension PropertyType {
    func bind<Property: PropertyType where Property.Value == Value>(to property: Property) -> Disposable {
        property.value = value
        return bind(to: property, transform: { $0.next }, isFailureTermination: true)
    }
}

extension SourceType {
    func bind<Property: PropertyType>(to property: Property, transform: (Element -> Property.Value?), isFailureTermination: Bool) -> Disposable {
        return property.subscribed { _ in
            return subscribe { [weak property] element in
                guard let property = property else { return }
                
                if let newValue = transform(element) {
                    property.value = newValue
                } else if isFailureTermination {
                    property.stream.subject.disposables.prune()
                }
            }
        } ?? BooleanDisposable(disposed: true)
    }
}

// MARK: - Binding Operator
infix operator ~>> { associativity left precedence 95 }
infix operator ~>< { associativity left precedence 95 }

public func ~>><Source: SourceType, Property: PropertyType where Source.Element == Property.Value>(lhs: Source, rhs: Property) -> Disposable {
    return lhs.bind(to: rhs)
}

public func ~>><Source: SourceType, Property: PropertyType where Source.Element: EventType, Source.Element.Value == Property.Value>(lhs: Source, rhs: Property) -> Disposable {
    return lhs.bind(to: rhs)
}

public func ~>><P1: PropertyType, P2: PropertyType where P1.Value == P2.Value>(lhs: P1, rhs: P2) -> Disposable {
    return lhs.bind(to: rhs)
}

public func ~><<P1: PropertyType, P2: PropertyType where P1.Value == P2.Value>(lhs: P1, rhs: P2) -> Disposable {
    let left2right = lhs.bind(to: rhs)
    let right2left = rhs.bind(to: lhs)
    
    if left2right.disposed {
        return right2left
    } else if right2left.disposed {
        return left2right
    } else {
        return left2right + right2left
    }
}