//
//  CustomizeSignal.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/18.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class CustomizeSignal<I, O>: SignalDefaultOperator<I, O> {
    typealias Forwarder = (Signal<I>, Signal<O> -> Void) -> Void
    
    private let forwarder: Forwarder
    
    init(_ forwarder: Forwarder) {
        self.forwarder = forwarder
    }
    
    override func forward(sink: Signal<O>.Action) -> Signal<I> -> Void {
        return { signal in
            self.forwarder(signal, sink)
        }
    }
}