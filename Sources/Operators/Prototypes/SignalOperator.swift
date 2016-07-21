//
//  SignalOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public class SignalOperator<I, O>: OperatorType {
    public func forward(sink: Signal<O>.Action) -> Signal<I>.Action {
        RevealUnimplemented()
    }
    
    public func forwardResponse<E>(sink: Response<O, E>.Action) -> Response<I, E>.Action {
        RevealUnimplemented()
    }
}

extension SignalOperator {
    func signalForwarder<E>(response responseSink: Response<O, E>.Action) -> Signal<I>.Action {
        return forward { signal in
            switch signal {
            case .next(let value):
                responseSink(.next(value))
            case .completed:
                responseSink(.completed)
            }
        }
    }
}