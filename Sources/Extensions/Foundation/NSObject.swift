//
//  FoundationExtensions.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/31.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

private var LifeTimeKey: Int32 = 0
private var AssociatedPropertiesKey: Int32 = 0
private var DisposableCollectorKey: Int32 = 0

public extension NSObject {
    var rLifeTime: LifeTime {
        return associatedObject(for: &LifeTimeKey, initial: LifeTime("\(self) - deallocated"))
    }
    
    func rProperty<T>(keyPath: String, as type: T.Type) -> KeyValueProperty<T> {
        return KeyValueProperty(object: self, keyPath: keyPath)
    }
    
    func rProperty<T>(keyPath: String, as type: Optional<T>.Type) -> KeyValueProperty<T?> {
        return KeyValueProperty(object: self, keyPath: keyPath) { object in
            return object === kCFNull ? nil : (object as! T)
        }
    }
    
    func rSink<T>(keyPath: String, as type: T.Type) -> KeyValueSink<T> {
        return KeyValueSink(object: self, keyPath: keyPath)
    }
}

public extension NSObjectProtocol where Self: NSObject {
    func rSink<T>(type: T.Type, setter: (Self, T) -> Void) -> ObjectSink<Self, T> {
        return ObjectSink(object: self, setter: setter)
    }
    
    func rAssociatedProperty<T>(key: String, initial: T, setter: (Self, T) -> Void, @noescape updater: (Property<T> -> Void)) -> Property<T> {
        let associatedProperties = associatedObject(for: &AssociatedPropertiesKey, initial: NSMutableDictionary())
        
        if let property = associatedProperties.objectForKey(key) {
            return property as! Property<T>
        } else {
            let property = Property<T>("\(self.dynamicType) - \(key)", initialValue: initial)
            associatedProperties.setObject(property, forKey: key)
            
            property.subscribeNext { [weak self] value in
                if let weakSelf = self {
                    setter(weakSelf, value)
                }
            }
            
            updater(property)
            
            return property
        }
    }
}

// MARK: - DisposableCollectorOwnerType
extension NSObject: DisposableCollectorOwnerType {
    public var disposableCollector: DisposableCollector {
        return associatedObject(for: &DisposableCollectorKey, initial: DisposableCollector())
    }
    
    func associatedObject<T: AnyObject>(for key: UnsafeMutablePointer<Void>, @autoclosure initial: Void -> T) -> T {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if let object = objc_getAssociatedObject(self, key) {
            return object as! T
        } else {
            let initialValue = initial()
            objc_setAssociatedObject(self, key, initialValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return initialValue
        }
    }
}