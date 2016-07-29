//
//  Merge.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/29.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// TODO

final class MergeSignal<Value, Source: SourceType where Source.Element == Signal<Value>>: ValueCustomOperator<Source, Value> {
    private var atomicInFlight = Atomic(UInt(1))
    private let disposables = CompositeDisposable()
    private var completionSink: (Void -> Void)?
    
    override init() {  }
    
    deinit {
        disposables.dispose()
    }
    
    override func forward(sink: Sink) -> Source {
        return { source in
            var subscription: Disposable!
            
            subscription = source.subscribe { signal in
                if case .next(let value) = signal {
                    self.atomicInFlight.with { inFlight in
                        guard inFlight != 0 else { return }
                        
                        sink(value)
                    }
                } else {
                    subscription.dispose()
                    self.decrementInFlight()
                }
            }
            
            self.disposables.append(subscription)
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void) {
        self.completionSink = completionSink
        return decrementInFlight
    }
    
    private func decrementInFlight() {
        if let completionSink = completionSink {
            let originalInFlight = atomicInFlight.swap { inFlight in
                if inFlight == 1 {
                    completionSink()
                }
                
                return inFlight - 1
            }
            
            if originalInFlight == 1 {
                disposables.dispose()
            }
        }
    }
}

final class MergeResponse<Value, Error: ErrorType, Source: SourceType where Source.Element == Response<Value, Error>>: ValueOperator<Source, Value> {
    
}