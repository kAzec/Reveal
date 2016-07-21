//
//  Functions.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

func identity<T>(value: T) -> T {
    return value
}

@noreturn
func RevealUnimplemented() {
    fatalError("Abstract method not implemented.")
}

infix operator ∘ { associativity left precedence 140 }
func ∘<A, B, C>(rhs: A -> B, lhs: B -> C) -> (A -> C) {
    return { lhs(rhs($0)) }
}