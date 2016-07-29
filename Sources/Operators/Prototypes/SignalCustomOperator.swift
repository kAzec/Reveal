//
//  SignalCustomOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// Currently no operator interits from SignalCustomOperator.
class SignalCustomOperator<IV, OV>: SignalOperator<IV, OV> {
    func forwarder<E: ErrorType>(failure failureSink: E -> Void, completion completionSink: Void -> Void, next valueSink: ValueSink) -> (E -> Void) {
        RevealUnimplemented()
    }
    
    final override func forwardResponse<E>(sink: Response<OV, E>.Action) -> Response<IV, E>.Action {
        let onFailure = forwarder(
            failure:    { sink(.failed($0)) },
            completion: { sink(.completed)  },
            next:       { sink(.next($0))   }
        )
        
        let onSignal = convertAsSignalForwarder(sink)
        
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

extension SignalOperator {
    func convertAsSignalForwarder<E>(responseSink: Response<OV, E>.Action) -> Source {
        return forward { signal in
            if case .next(let value) = signal {
                responseSink(.next(value))
            } else {
                responseSink(.completed)
            }
        }
    }
}