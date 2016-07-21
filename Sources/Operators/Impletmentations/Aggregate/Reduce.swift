//
//  Reduce.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Reduce<T, U>: SignalOperator<T, U> {
    private var last: U
    private let combine: (U, T) -> U
    
    init(_ initial: U, combine: (U, T) -> U) {
        self.last = initial
        self.combine = combine
    }
    
    override func forward(sink: Signal<U>.Action) -> Signal<T>.Action {
        return { signal in
            switch signal {
            case .next(let element):
                self.last = self.combine(self.last, element)
            case .completed:
                sink(.next(self.last))
                sink(.completed)
            }
        }
    }
}