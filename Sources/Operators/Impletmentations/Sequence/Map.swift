//
//  Map.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/17.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Map<I, O>: ValueDefaultOperator<I, O> {
    let transform: I -> O
    
    init(_ transform: I -> O) {
        self.transform = transform
    }
    
    override func forward(sink: O -> Void) -> (I -> Void) {
        return { value in
            sink(self.transform(value))
        }
    }
}

public func map<I, O>(transform: I -> O) -> ValueOperator<I, O> {
    return Map(transform)
}