//
//  Scan.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Scan<I, O>: ValueDefaultOperator<I, O> {
    private var last: O
    private let combine: (O, I) -> O
    
    init(_ initial: O, combine: (O, I) -> O) {
        self.last = initial
        self.combine = combine
    }
    
    override func forward(sink: Sink) -> Source {
        return { value in
            self.last = self.combine(self.last, value)
            sink(self.last)
        }
    }
}