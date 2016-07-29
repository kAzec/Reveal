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
        let onNext = forward{ sink(.next($0)) }
        
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
        let onNext = forward{ sink(.next($0)) }
        
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