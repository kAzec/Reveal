//
//  Box.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/17.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Box<T> {
    let value: T
    
    init(_ value: T) {
        self.value = value
    }
}