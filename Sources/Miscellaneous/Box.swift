//
//  Box.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/31.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Box<T> {
    var value: T
    
    init(_ value: T) {
        self.value = value
    }
}