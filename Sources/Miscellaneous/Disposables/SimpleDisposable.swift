//
//  SimpleDisposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/12.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

final class SimpleDisposable: Disposable {
    var atomicDisposed = AtomicBool(false)
    
    var disposed: Bool {
        return atomicDisposed.boolValue
    }
    
    init() {  }
    
    func dispose() {
        atomicDisposed.swap(true)
    }
}