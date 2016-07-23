//
//  Operator+Error.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/24.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public func tryMap<I, O, E>(transform: I -> Result<O, E>) -> ResponseOperator<I, E, O, E> {
    return TryMap(transform)
}

public func mapError<T, E, F>(transform: E -> F) -> ResponseOperator<T, E, T, F> {
    return MapError(transform)
}