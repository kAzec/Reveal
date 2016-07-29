//
//  ComposeNode.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/10.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class ComposeNode<A, B, C>: ValueOperator<A, C> {
    private let left: ValueOperator<A, B>
    private let right: ValueOperator<B, C>
    
    init(left: ValueOperator<A, B>, right: ValueOperator<B, C>) {
        self.left = left
        self.right = right
    }
    
    override func forward(sink: Sink) -> Source {
        return left.forward(right.forward(sink))
    }

    override func forwardSignal(sink: Signal<C>.Action) -> Signal<A>.Action {
        return left.forwardSignal(right.forwardSignal(sink))
    }
    
    override func forwardResponse<E>(sink: Response<C, E>.Action) -> Response<A, E>.Action {
        return left.forwardResponse(right.forwardResponse(sink))
    }
}
