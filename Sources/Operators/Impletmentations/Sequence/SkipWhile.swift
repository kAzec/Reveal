//
//  SkipWhile.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class SkipWhile<T>: ControlWithPredicate<T> {
    override init(_ predicate: T -> Bool) {
        super.init(predicate)
    }
    
    override var exceptation: Bool {
        return false
    }
}