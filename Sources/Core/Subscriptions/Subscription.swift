//
//  Subscription.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

/// Subscription to source, disposable.
public final class Subscription<Source: SourceType>: Disposable {
    public weak var source: Source?
    
    var removal: (Source -> Void)?
    var atomicDisposed: AtomicBool
    
    init() {
        self.source = nil
        self.removal = nil
        self.atomicDisposed = AtomicBool(true)
    }
    
    init(source: Source, removal: Source -> Void) {
        self.source = source
        self.removal = removal
        self.atomicDisposed = AtomicBool(false)
    }
    
    public func dispose() {
        guard !atomicDisposed.swap(true) else { return }
        
        if let src = source {
            removal!(src)
            source = nil
            removal = nil
        }
        
    }
    
    public var disposed: Bool {
        return atomicDisposed.boolValue || source == nil
    }
}