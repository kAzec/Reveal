//
//  TimerDisposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/26.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class TimerDisposable: Disposable {
    var atomicDisposed = AtomicBool(false)
    var timer: dispatch_source_t?
    
    init(_ timer: dispatch_source_t) {
        self.timer = timer
    }
    
    func dispose() {
        if !atomicDisposed.swap(true) {
            let timer = self.timer!
            self.timer = nil
            dispatch_source_cancel(timer)
        }
    }
    
    var disposed: Bool {
        return atomicDisposed.boolValue
    }
}