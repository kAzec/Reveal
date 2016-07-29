//
//  CustomizeSignal.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/18.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class CustomizeSignal<IV, OV>: SignalDefaultOperator<IV, OV> {
    typealias Forwarder = (I, Sink) -> Void
    
    private let forwarder: Forwarder
    
    init(_ forwarder: Forwarder) {
        self.forwarder = forwarder
    }
    
    override func forward(sink: Sink) -> Source {
        return { signal in
            self.forwarder(signal, sink)
        }
    }
}