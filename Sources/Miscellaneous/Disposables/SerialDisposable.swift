//
//  SerialDisposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/3/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

/// A disposable that will optionally dispose of another disposable.
final class SerialDisposable: Disposable {
    private var atomicDisposed = AtomicBool(false)
    private let atomicDisposable: Atomic<Disposable?>
    
    var disposed: Bool {
        return atomicDisposed.boolValue
    }
    
    var innerDisposable: Disposable? {
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
    
    init(_ disposable: Disposable? = nil) {
        self.atomicDisposable = Atomic(disposable)
    }
    
    func dispose() {
        guard !atomicDisposed.swap(true) else { return }
        
        if let disposable = atomicDisposable.swap(nil) {
            disposable.dispose()
        }
    }
}