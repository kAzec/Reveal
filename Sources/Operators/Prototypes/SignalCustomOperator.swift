//
//  SignalCustomOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class SignalCustomOperator<I, O>: SignalOperator<I, O> {
    func forwardFailure<E: ErrorType>(failure failureSink: E -> Void, completion completionSink: Void -> Void, next nextSink: O -> Void) -> (E -> Void) {
        RevealUnimplemented()
    }
    
    final override func forwardResponse<E>(responseSink: Response<O, E>.Action) -> Response<I, E>.Action {
        let onSignal = signalForwarder(response: responseSink)
        
        let onFailure = forwardFailure(
            failure:    { responseSink(.failed($0)) },
            completion: { responseSink(.completed)  },
            next:       { responseSink(.next($0))   }
        )
        
        return { response in
            switch response {
            case .next(let value):
                onSignal(.next(value))
            case .failed(let error):
                onFailure(error)
            case .completed:
                onSignal(.completed)
            }
        }
    }

}