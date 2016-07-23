//
//  Times.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Times<T>: ValueDefaultOperator<T, T> {
    private let multiplier: Int
    
    init(_ multiplier: Int) {
        precondition(multiplier >= 0)
        self.multiplier = multiplier
    }
    
    override func forward(sink: T -> Void) -> (T -> Void) {
        guard multiplier > 0 else {
            return { [sink] _ in let _ = sink }
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
}