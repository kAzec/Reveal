//
//  CompositeDisposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/28.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class CompositeDisposable: Disposable {
    public var disposed: Bool {
        return atomicDisposed.boolValue
    }
    
    private var atomicDisposed = AtomicBool(false)
    private var atomicDisposables: Atomic<Array<Disposable>?>
    
    public init() {
        atomicDisposables = Atomic([])
    }
    
    public init<S: SequenceType where S.Generator.Element == Disposable>(_ disposables: S) {
        atomicDisposables = Atomic(Array(disposables))
    }
    
    public func append(disposable: Disposable) {
        if atomicDisposed { return disposable.dispose() }
        if disposable.disposed { return }
        
        atomicDisposables.modify {
            $0 = $0!.filter{ $0.disposed }
            $0!.append(disposable)
        }
    }
    
    public func append<S: SequenceType where S.Generator.Element == Disposable>(disposables: S) {
        if atomicDisposed {
            for disposable in disposables {
                disposable.dispose()
            }
        }
        
        atomicDisposables.modify {
            $0!.appendContentsOf(disposables)
            $0 = $0!.filter{ $0.disposed }
        }
    }
    
    public func prune() {
        if atomicDisposed { return }
        
        atomicDisposables.modify {
            $0 = $0!.filter{ $0.disposed }
        }
    }
    
    public func dispose() {
        if atomicDisposed.swap(true) { return }
        for disposable in atomicDisposables.swap(nil)!.reverse() {
            disposable.dispose()
        }
    }
}

public func +=(lhs: CompositeDisposable, rhs: Disposable?) {
    if let disposable = rhs {
        lhs.append(disposable)
    }
}

public func +=(lhs: CompositeDisposable, rhs: Disposable) {
    lhs.append(rhs)
}

public func +=(lhs: CompositeDisposable, rhs: Void -> Void) {
    lhs.append(AnonymousDisposable(rhs))
}