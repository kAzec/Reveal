//
//  ValueCustomOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class ValueCustomOperator<I, O>: ValueOperator<I, O> {
    func forwardCompletion(completion completionSink: Void -> Void, next nextSink: O -> Void) -> (Void -> Void) {
        RevealUnimplemented()
    }
    
    final override func forwardSignal(sink: Signal<O>.Action) -> Signal<I>.Action {
        let nextSink = { sink(.next($0)) }
        let completionSink = { sink(.completed) }
        
        let onNext = forward(nextSink)
        
        let onCompletion = forwardCompletion(
            completion: completionSink,
            next:       nextSink
        )
        
        return { signal in
            switch signal {
            case .next(let value):
                onNext(value)
            case .completed:
                onCompletion()
            }
        }
    }
    
    final override func forwardResponse<E>(sink: Response<O, E>.Action) -> Response<I, E>.Action {
        let nextSink = { sink(.next($0)) }
        let completionSink = { sink(.completed) }
        
        let onNext = forward(nextSink)
        
        let onCompletion = forwardCompletion(
            completion: completionSink,
            next:       nextSink
        )
        
        return { response in
            switch response {
            case .next(let value):
                onNext(value)
            case .completed:
                onCompletion()
            case .failed(let error):
                sink(.failed(error))
            }
        }
    }
}