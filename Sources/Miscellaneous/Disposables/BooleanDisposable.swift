//
//  BooleanDisposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/12.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class BooleanDisposable: Disposable {
    public private(set) var disposed: Bool
    
    public init(disposed: Bool = false) {
        self.disposed = disposed
    }
    
    public func dispose() {
        disposed = true
    }
}