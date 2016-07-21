//
//  CustomizeResponse.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/18.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class CustomizeResponse<I, E: ErrorType, O, F: ErrorType>: ResponseOperator<I, E, O, F> {
    typealias Forwarder = (Response<I, E>, Response<O, F> -> Void) -> Void
    
    private let forwarder: Forwarder
    
    init(_ forwarder: Forwarder) {
        self.forwarder = forwarder
    }
    
    override func forward(sink: Response<O, F>.Action) -> Response<I, E> -> Void {
        return { response in
            self.forwarder(response, sink)
        }
    }
}