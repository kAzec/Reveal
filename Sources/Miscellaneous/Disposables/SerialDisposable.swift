//
//  SerialDisposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/3/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

/// A disposable that will optionally dispose of another disposable.
public final class SerialDisposable: Disposable {
    private var atomicDisposed = AtomicBool(false)
    private let atomicDisposable: Atomic<Disposable?>
    
    public var disposed: Bool {
        return atomicDisposed.boolValue
    }
    
    public var innerDisposable: Disposable? {
        get {
            return atomicDisposable.value
        }
        
        set {
            if atomicDisposed {
                newValue?.dispose()
            } else {
                atomicDisposable.swap(newValue)?.dispose()
            }
        }
    }
    
    public init(_ disposable: Disposable? = nil) {
        self.atomicDisposable = Atomic(disposable)
        print("\(self) inited with \(disposable)")
    }
    
    public func dispose() {
        if atomicDisposed.swap(true) { return }
        
        if let disposable = atomicDisposable.swap(nil) {
            disposable.dispose()
        }
        
        print("\(self) disposed")
    }
}