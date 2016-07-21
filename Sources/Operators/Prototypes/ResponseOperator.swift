//
//  ResponseOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public class ResponseOperator<I, E: ErrorType, O, F: ErrorType>: OperatorType {
    public func forward(sink: Response<O, F>.Action) -> Response<I, E>.Action {
        RevealUnimplemented()
    }
}