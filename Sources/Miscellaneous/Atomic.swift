//
//  Atomic.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/2/24.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

/// An atomic variable.
public final class Atomic<T> {
    /// The lock used to perform atomic operations.
    var mutex = UnsafeMutablePointer<pthread_mutex_t>.alloc(1)
    
    var atomicValue: T
    
    /// Atomically get/set the value.
    public var value: T {
        get {
            pthread_mutex_lock(mutex); defer { pthread_mutex_unlock(mutex) }
            
            return atomicValue
        }
        
        set {
            swap(newValue)
        }
    }
    
    /**
     Create a new atomic wrapper for given initial value.
     
     - parameter value: The initial value.
     
     - returns: New atomic with initial value.
     */
    public init(_ value: T) {
        pthread_mutex_init(mutex, nil)
        self.atomicValue = value
    }
    
    deinit {
        pthread_mutex_destroy(mutex)
        mutex.destroy()
        mutex.dealloc(1)
    }
    
    /**
     Atomically replace the value with result of the `replacement` closure and return the value it held before.
     
     - parameter replacement: The replacement closure.
     
     - returns: The old value.
     */
    public func swap(@noescape replacement: T throws -> T) rethrows -> T {
        pthread_mutex_lock(mutex); defer { pthread_mutex_unlock(mutex) }
        
        let oldValue = atomicValue
        atomicValue = try replacement(atomicValue)
        return oldValue
    }
    
    /**
     Atomically replaces the value with new value and return the value it held before.
     
     - parameter newValue: The new value.
     
     - returns: The old value.
     */
    public func swap(newValue: T) -> T {
        pthread_mutex_lock(mutex); defer { pthread_mutex_unlock(mutex) }
        
        let oldValue = atomicValue
        atomicValue = newValue
        return oldValue
    }
    
    /**
     Atomically performs an arbitrary modification action with the current value.
     
     - parameter modification: The modification closure.
     - returns: The result of the action.
     */
    public func modify<U>(@noescape modification: inout T throws -> U) rethrows -> U {
        pthread_mutex_lock(mutex); defer { pthread_mutex_unlock(mutex) }
        
        return try modification(&atomicValue)
    }

    /**
     Atomically performs an arbitrary action using the current value.
     
     - parameter action: The action closure.

     - returns: The result of the action.
     */
    public func with<U>(@noescape action: T throws -> U) rethrows -> U {
        pthread_mutex_lock(mutex); defer { pthread_mutex_unlock(mutex) }
        
        return try action(atomicValue)
    }
}