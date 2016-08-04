//
//  AnonymousDisposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/25.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class AnonymousDisposable: Disposable {
    var handler: (Void -> Void)?
    var atomicDisposed: AtomicBool
    
    public var disposed: Bool {
        return atomicDisposed.boolValue
    }
    
    public init(_ handler: (Void -> Void)?) {
        self.handler = handler
        atomicDisposed = AtomicBool(handler == nil)
    }
    
    public func dispose() {
        if atomicDisposed.swap(true) { return }
        
        handler.swap(nil)!()
    }
}