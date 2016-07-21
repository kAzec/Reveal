//
//  Signal.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/3/31.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public enum Signal<Value> {
    case next(Value)
    case completed
}

public extension Signal {
    typealias Action = Signal -> Void
    
    var next: Value? {
        if case .next(let value) = self {
            return value
        } else {
            return nil
        }
    }
    
    var completing: Bool {
        if case .completed = self {
            return true
        } else {
            return false
        }
    }
    
    func map<U>(@noescape transform: Value -> U) -> Signal<U> {
        switch self {
        case .next(let value):
            return .next(transform(value))
        case .completed:
            return .completed
        }
    }
}