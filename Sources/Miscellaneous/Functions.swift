//
//  Functions.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

/// Indicates the function is abstract.
@noreturn
func RevealUnimplemented(file: String = #file, line: Int = #line, function: String = #function) {
    fatalError("Method: \(function) is abstract. File: \(file), line: \(line)")
}

// MARK: - Funtionals

/// Identical transform.
func id<T>(value: T) -> T {
    return value
}

/// Compose function.
func compose<A, B, C>(lhs: A -> B, _ rhs: B -> C) -> (A -> C) {
    return { rhs(lhs($0)) }
}

/// Lift observee over certain transform.
func apply<A, B, U>(transform: A -> B, to observee: (A -> Void) -> U) -> ((B -> Void) -> U) {
    return { observee(compose(transform, $0)) }
}