//
//  Flatten.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/29.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Flatten<S: SequenceType>: ValueDefaultOperator<S, S.Generator.Element> {
    override func forward(sink: Sink) -> Source {
        return { sequence in
            for value in sequence {
                sink(value)
            }
        }
    }
}