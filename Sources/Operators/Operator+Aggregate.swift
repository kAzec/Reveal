//
//  Operator+Aggregate.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/24.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public func collect<T>(count: Int) -> ValueOperator<T, [T]> {
    return CollectCount(count)
}

public func collect<T>() -> SignalOperator<T, [T]> {
    return Collect()
}

public func reduce<T, U>(initial: U, combine: (U, T) -> U) -> SignalOperator<T, U> {
    return Reduce(initial, combine: combine)
}