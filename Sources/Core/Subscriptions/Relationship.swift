//
//  Relationship.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

/// Bidirectional subscription.
public final class Relationship<M1: IntermediateType, M2: IntermediateType>: Disposable {
    public weak var intermediate1: M1?
    public weak var intermediate2: M2?
    var removal: ((M1, M2) -> Void)?
    
    var atomicDisposed = AtomicBool(false)
    
    init(intermediate1: M1, intermediate2: M2, removal: (M1, M2) -> Void) {
        self.intermediate1 = intermediate1
        self.intermediate2 = intermediate2
        self.removal = removal
    }
    
    public func dispose() {
        guard !atomicDisposed.swap(true) else { return }
        
        if let src = intermediate1 {
            removal!(src, intermediate2!)
            intermediate1 = nil
            intermediate2 = nil
            removal = nil
        }
    }
    
    public var disposed: Bool {
        return atomicDisposed.boolValue || intermediate1 == nil || intermediate2 == nil
    }
}