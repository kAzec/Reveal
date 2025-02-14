//
//  Filter.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Filter<T>: ValueDefaultOperator<T, T> {
    private let includeValue: T -> Bool
    
    init(_ includeValue: T -> Bool) {
        self.includeValue = includeValue
    }
    
    override func forward(sink: Sink) -> Source {
        return { value in
            if self.includeValue(value) {
                sink(value)
            }
        }
    }
}