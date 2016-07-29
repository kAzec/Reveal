//
//  Optional+Swap.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/29.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

extension Optional {
    /// Swap contents of Optional.
    mutating func swap(value: Optional) -> Optional {
        let old = self
        self = value
        return old
    }
}