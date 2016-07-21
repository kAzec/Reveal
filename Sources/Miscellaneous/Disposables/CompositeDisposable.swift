//
//  CompositeDisposable.swift
//  Flowing
//
//  Created by 锋炜 刘 on 16/3/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

/// A disposable that disposes a collection of disposables upon disposing.
public class CompositeDisposable: Disposable {
    
    public final var disposed: Bool {
        return disposables.value == nil
    }
    
    private var disposables: Atomic<Bag<Disposable>?>
    
    public init() {
        self.disposables = Atomic(Bag())
    }
    
    public init<S: SequenceType where S.Generator.Element == Disposable>(_ disposables: S) {
        self.disposables = Atomic(Bag(disposables))
    }
    
    public final func append(disposable: Disposable) -> UInt? {
        return disposables.modify { bag in
            guard var bag = bag else {
                disposable.dispose()
                return nil
            }
            
            return bag.append(disposable)
        }
    }
    
    public final func dispose() {
        disposables.swap { disposables in
            guard let disposables = disposables else {
                return nil
            }
            
            for disposable in disposables {
                disposable.dispose()
            }
            
            return nil
        }
    }
}

public func += (lhs: CompositeDisposable, rhs: Disposable?) {
    if let disposable = rhs {
        lhs.append(disposable)
    }
}