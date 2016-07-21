//
//  Disposable.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public protocol Disposable: class {
    var disposed: Bool { get }
    
    /**
     Atomically disposition action.
     */
    func dispose()
}