//
//  ComposeResponse.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/29.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class ComposeResponse<A, E: ErrorType, B, F: ErrorType, C, G: ErrorType>: ResponseOperator<A, E, C, G> {
    private let left: ResponseOperator<A, E, B, F>
    private let right: ResponseOperator<B, F, C, G>
    
    init(left: ResponseOperator<A, E, B, F>, right: ResponseOperator<B, F, C, G>) {
        self.left = left
        self.right = right
    }
    
    override func forward(sink: Sink) -> Source {
        return left.forward(right.forward(sink))
    }
}