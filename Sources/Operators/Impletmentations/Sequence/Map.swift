//
//  Map.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/17.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Map<I, O>: ValueDefaultOperator<I, O> {
    private let transform: I -> O
    
    init(_ transform: I -> O) {
        self.transform = transform
    }
    
    override func forward(sink: Sink) -> Source {
        return { value in
            sink(self.transform(value))
        }
    }
}