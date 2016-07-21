//
//  BinaryDisposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

public final class BinaryDisposable<D1: Disposable, D2: Disposable>: Disposable {
    
    private var atomicDisposed = AtomicBool(false)
    
    public private(set) var disposable1: D1?
    public private(set) var disposable2: D2?
    
    public var disposed: Bool {
        return atomicDisposed.boolValue
    }
    
    init(_ disposable1: D1? = nil, _ disposable2: D2? = nil) {
        self.disposable1 = disposable1
        self.disposable2 = disposable2
    }

    public func dispose() {
        if !atomicDisposed.swap(true) {
            let disposable1 = self.disposable1!
            let disposable2 = self.disposable2!
            
            self.disposable1 = nil
            self.disposable2 = nil
            
            disposable1.dispose()
            disposable2.dispose()
        }
    }
}