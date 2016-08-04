//
//  IgnoreNil.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/3/20.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class IgnoreNil<Wrapped>: ValueDefaultOperator<Wrapped?, Wrapped> {
    override func forward(sink: Sink) -> Source {
        return { optional in
            if let unwrapped = optional {
                sink(unwrapped)
            }
        }
    }
}