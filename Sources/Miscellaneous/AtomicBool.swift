//
//  AtomicBool.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

/**
 * Atomic boolean value.
 */
public struct AtomicBool: BooleanType {
    var byte: UInt8 = 0
    
    public init(_ value: Bool) {
        self.byte = (value == false ? 0 : 1)
    }
    
    /**
     Atomically replaces the bool value with new value and return the value it held before.
     
     - parameter newValue: The new bool value.
     
     - returns: The old bool value.
     */
    public mutating func swap(newValue: Bool) -> Bool {
        if newValue {
            return  OSAtomicTestAndSet(7, &byte)
        } else {
            return  OSAtomicTestAndClear(7, &byte)
        }
    }
    
    /// The boolean value.
    public var boolValue: Bool {
        return byte != 0
    }
}