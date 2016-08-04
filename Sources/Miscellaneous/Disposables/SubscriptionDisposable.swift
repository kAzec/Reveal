//
//  SubscriptionDisposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/25.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class SubscriptionDisposable<Source: BaseIntermediateType>: Disposable {
    private weak var source: Source?
    private let removalToken: UInt
    private var atomicDisposed = AtomicBool(false)
    
    init(source: Source, removalToken: UInt) {
        self.source = source
        self.removalToken = removalToken
    }
    
    var disposed: Bool {
        if atomicDisposed.boolValue {
            return true
        }
        
        if source?.subject.disposed.boolValue ?? true {
            atomicDisposed.swap(true)
            return true
        }
        
        return false
    }
    
    func dispose() {
        if atomicDisposed.swap(true) { return }
        
        if let source = source where !source.subject.disposed {
            source.subject.actions.modify { actions in
                actions?.remove(for: removalToken)
            }
        }
        
        source = nil
    }
}