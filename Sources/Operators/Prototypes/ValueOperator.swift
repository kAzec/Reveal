//
//  ValueOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public class ValueOperator<I, O>: OperatorType {
    public func forward(sink: O -> Void) -> (I -> Void) {
        RevealUnimplemented()
    }
    
    public func forwardSignal(sink: Signal<O>.Action) -> Signal<I>.Action {
        RevealUnimplemented()
    }
    
    public func forwardResponse<E>(sink: Response<O, E>.Action) -> Response<I, E>.Action {
        RevealUnimplemented()
    }
}

extension ValueOperator {
    func nextForwarder(signal signalSink: Signal<O>.Action) -> (I -> Void) {
        return forward{ signalSink(.next($0)) }
    }
    
    func nextForwarder<E>(response responseSink: Response<O, E>.Action) -> (I -> Void) {
        return forward{ responseSink(.next($0)) }
    }
    
    func signalForwarder<E>(response responseSink: Response<O, E>.Action) -> Signal<I>.Action {
        return forwardSignal { signal in
            switch signal {
            case .next(let value):
                responseSink(.next(value))
            case .completed:
                responseSink(.completed)
            }
        }
    }
}