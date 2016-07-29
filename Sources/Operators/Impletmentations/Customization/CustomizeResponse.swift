//
//  CustomizeResponse.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/18.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class CustomizeResponse<IV, E: ErrorType, OV, F: ErrorType>: ResponseOperator<IV, E, OV, F> {
    typealias Forwarder = (I, Sink) -> Void
    
    private let forwarder: Forwarder
    
    init(_ forwarder: Forwarder) {
        self.forwarder = forwarder
    }
    
    override func forward(sink: Sink) -> Source {
        return { response in
            self.forwarder(response, sink)
        }
    }
}