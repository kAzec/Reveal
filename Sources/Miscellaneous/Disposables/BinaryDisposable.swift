//
//  BinaryDisposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class BinaryDisposable: Disposable {
    
    private var atomicDisposed = AtomicBool(false)

    var pair: (left: Disposable, right: Disposable)?
    
    public var left: Disposable? {
        return pair?.left
    }
    
    public var right: Disposable? {
        return pair?.right
    }
    
    public var disposed: Bool {
        return atomicDisposed.boolValue
    }
    
    init(_ disposable1: Disposable, _ disposable2: Disposable) {
        pair = (disposable1, disposable2)
    }

    public func dispose() {
        if !atomicDisposed.swap(true) {
            let (left, right) = pair.swap(nil)!
            
            left.dispose()
            right.dispose()
        }
    }
}

public func +(lhs: Disposable, rhs: Disposable) -> BinaryDisposable {
    return BinaryDisposable(lhs, rhs)
}