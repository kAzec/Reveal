//
//  TakeLast.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class TakeLast<T>: SignalDefaultOperator<T, T> {
    private var buffer: Ring<T>
    
    init(_ count: Int) {
        precondition(count >= 0)
        buffer = Ring(capacity: count)
    }
    
    func forward(sink: Signal<[T]>.Action) -> Signal<T>.Action {
        guard buffer.capacity > 0 else {
            return { [sink] _ in let _ = sink }
        }
        
        return { signal in
            switch signal {
            case .next(let value):
                self.buffer.enqueue(value)
            case .completed:
                if self.buffer.count > 0 {
                    let values = Array(self.buffer)
                    let capacity = self.buffer.capacity
                    
                    self.buffer = Ring<T>(capacity: capacity)
                    
                    sink(.next(values))
                    sink(.completed)
                }
            }
        }
    }
}

final class TakeLastOne<T>: SignalDefaultOperator<T, T> {
    private var buffer: T?
    
    override init() {  }
    
    override func forward(sink: Signal<T>.Action) -> Signal<T>.Action {
        return { signal in
            switch signal {
            case .next(let value):
                self.buffer = value
            case .completed:
                if let last = self.buffer {
                    sink(.next(last))
                }
                sink(.completed)
            }
        }
    }
}