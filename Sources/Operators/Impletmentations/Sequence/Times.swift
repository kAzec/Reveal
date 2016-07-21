//
//  Times.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Times<T>: ValueDefaultOperator<T, T> {
    private let count: Int
    
    init(_ count: Int) {
        precondition(count >= 0)
        self.count = count
    }
    
    override func forward(sink: T -> Void) -> (T -> Void) {
        guard count > 0 else {
            return { [sink] _ in let _ = sink }
        }
        
        guard count > 1 else {
            return sink
        }
        
        return { value in
            var remainingTimes = self.count
            
            while remainingTimes > 0 {
                remainingTimes -= 1
                sink(value)
            }
        }
    }
}