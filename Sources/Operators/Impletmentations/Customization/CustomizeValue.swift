//
//  CustomizeValue.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class CustomizeValue<I, O>: ValueDefaultOperator<I, O> {
    typealias Forwarder = (I, Sink) -> Void
    
    private let forwarder: Forwarder
    
    init(_ forwarder: Forwarder) {
        self.forwarder = forwarder
    }
    
    override func forward(sink: Sink) -> Source {
        return { element in
            self.forwarder(element, sink)
        }
    }
}