//
//  ComposeStream.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/26.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class ComposeStream<A, B, C>: SignalOperator<A, C> {
    private let left: SignalOperator<A, B>
    private let right: SignalOperator<B, C>
    
    init(left: SignalOperator<A, B>, right: SignalOperator<B, C>) {
        self.left = left
        self.right = right
    }
    
    override func forward(sink: Sink) -> Source {
        return left.forward(right.forward(sink))
    }
    
    override func forwardResponse<E>(sink: Response<C, E>.Action) -> Response<A, E>.Action {
        return left.forwardResponse(right.forwardResponse(sink))
    }
}