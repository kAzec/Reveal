//
//  IO.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/14.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

enum IO<I, O> {
    typealias Raw = (O -> Void) -> (I -> Void)
}