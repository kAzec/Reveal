//
//  ValueDefaultOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class ValueDefaultOperator<I, O>: ValueOperator<I, O> {
    final override func forwardSignal(sink: Signal<O>.Action) -> Signal<I>.Action {
        let onNext = nextForwarder(signal: sink)
        
        return { signal in
            switch signal {
            case .next(let value):
                onNext(value)
            case .completed:
                sink(.completed)
            }
        }
    }
    
    final override func forwardResponse<E>(sink: Response<O, E>.Action) -> Response<I, E>.Action {
        let onNext = nextForwarder(response: sink)
        
        return { response in
            switch response {
            case .next(let value):
                onNext(value)
            case .failed(let error):
                sink(.failed(error))
            case .completed:
                sink(.completed)
            }
        }
    }
}