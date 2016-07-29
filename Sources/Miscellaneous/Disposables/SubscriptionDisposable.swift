//
//  SubscriptionDisposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/25.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class SubscriptionDisposable<I: IntermediateType>: Disposable {
    var atomicDisposed: AtomicBool
    
    weak var source: I?
    var removalToken: UInt?
    
    init() {
        source = nil
        removalToken = nil
        atomicDisposed = AtomicBool(true)
    }
    
    init(source: I, removalToken: UInt) {
        self.source = source
        self.removalToken = removalToken
        atomicDisposed = AtomicBool(false)
    }
    
    var disposed: Bool {
        return atomicDisposed.boolValue
    }
    
    func dispose() {
        if atomicDisposed.swap(true) { return }
        
        source?.subject.actions.modify { actions in
            actions?.remove(for: removalToken!)
        }
        
        source = nil
        removalToken = nil
    }
}