//
//  ValueCustomOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class ValueCustomOperator<I, O>: ValueOperator<I, O> {
    func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void) {
        RevealUnimplemented()
    }
    
    final override func forwardSignal(sink: Signal<O>.Action) -> Signal<I>.Action {
        let nextSink = { sink(.next($0)) }
        let completionSink = { sink(.completed) }
        
        let onCompletion = forwardCompletion(
            completion: completionSink,
            next:       nextSink
        )
        
        let onNext = forward(nextSink)
        
        return { signal in
            if case .next(let value) = signal {
                onNext(value)
            } else {
                onCompletion()
            }
        }
    }
    
    final override func forwardResponse<E>(sink: Response<O, E>.Action) -> Response<I, E>.Action {
        let nextSink = { sink(.next($0)) }
        let completionSink = { sink(.completed) }
        
        let onCompletion = forwardCompletion(
            completion: completionSink,
            next:       nextSink
        )

        let onNext = forward(nextSink)
        
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