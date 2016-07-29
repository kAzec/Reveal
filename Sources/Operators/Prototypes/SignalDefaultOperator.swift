//
//  SignalDefaultOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class SignalDefaultOperator<IV, OV>: SignalOperator<IV, OV> {
    final override func forwardResponse<E>(sink: Response<OV, E>.Action) -> Response<IV, E>.Action {
        let onSignal = convertAsSignalForwarder(sink)
        
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