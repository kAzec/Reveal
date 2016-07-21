//
//  SignalDefaultOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class SignalDefaultOperator<I, O>: SignalOperator<I, O> {
    final override func forwardResponse<E>(sink: Response<O, E>.Action) -> Response<I, E>.Action {
        let onSignal = signalForwarder(response: sink)
        
        return { response in
            switch response {
            case .next(let value):
                onSignal(.next(value))
            case .failed(let error):
                sink(.failed(error))
            case .completed:
                onSignal(.completed)
            }
        }
    }
}