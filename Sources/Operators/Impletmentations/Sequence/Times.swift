//
//  Times.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Times<T>: ValueCustomOperator<T, T> {
    private let multiplier: Int
    private var completionSink: (Void -> Void)?
    
    init(_ multiplier: Int) {
        precondition(multiplier >= 0)
        self.multiplier = multiplier
    }
    
    override func forward(sink: Sink) -> Source {
        guard multiplier > 0 else {
            completionSink?()
            return { _ in }
        }
        
        guard multiplier > 1 else {
            return sink
        }
        
        return { value in
            var remainingTimes = self.multiplier
            
            while remainingTimes > 0 {
                remainingTimes -= 1
                sink(value)
            }
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void) {
        self.completionSink = completionSink
        return completionSink
    }
}