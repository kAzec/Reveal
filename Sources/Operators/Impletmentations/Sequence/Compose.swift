//
//  Compose.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/10.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Compose<A, B, C>: ValueOperator<A, C> {
    private let o1: ValueOperator<A, B>
    private let o2: ValueOperator<B, C>
    
    init(_ o1: ValueOperator<A, B>, _ o2: ValueOperator<B, C>) {
        self.o1 = o1
        self.o2 = o2
    }
    
    override func forward(sink: C -> Void) -> (A -> Void) {
        return o1.forward(o2.forward(sink))
    }
    
    override func forwardSignal(sink: Signal<C>.Action) -> Signal<A>.Action {
        return o1.forwardSignal(o2.forwardSignal(sink))
    }
    
    override func forwardResponse<E>(sink: Response<C, E>.Action) -> Response<A, E>.Action {
        return o1.forwardResponse(o2.forwardResponse(sink))
    }
}

func +<A, B, C>(rhs: ValueOperator<A, B>, lhs: ValueOperator<B, C>) -> Compose<A, B, C> {
    return Compose(rhs, lhs)
}