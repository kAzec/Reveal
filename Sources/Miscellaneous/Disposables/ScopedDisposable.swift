//
//  ScopedDisposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/25.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

/// A disposable that, upon deinitialization, will automatically dispose of
/// another disposable.
public final class ScopedDisposable: Disposable {
    public private(set) weak var innerDisposable: Disposable?
    
    public var disposed: Bool {
        if let disposable = innerDisposable {
            if disposable.disposed {
                innerDisposable = nil
                return true
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    /// Initialize the receiver to dispose of the argument upon
    /// deinitialization.
    ///
    /// - parameters:
    ///   - disposable: A disposable to dispose of when deinitializing.
    public init(_ disposable: Disposable) {
        innerDisposable = disposable
    }
    
    deinit {
        dispose()
    }
    
    public func dispose() {
        innerDisposable.swap(nil)?.dispose()
    }
}