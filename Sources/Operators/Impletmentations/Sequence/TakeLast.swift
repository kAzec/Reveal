//
//  TakeLast.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class TakeLast<T>: SignalDefaultOperator<T, [T]> {
    private var buffer: Ring<T>
    
    init(_ count: Int) {
        precondition(count >= 0)
        buffer = Ring(length: count)
    }
    
    override func forward(sink: Sink) -> Source {
        guard buffer.length > 0 else {
            sink(.completed)
            return { _ in }
        }
        
        return { signal in
            switch signal {
            case .next(let value):
                self.buffer.enqueue(value)
            case .completed:
                if self.buffer.count > 0 {
                    let values = Array(self.buffer)
                    self.buffer.removeAll()
                    
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
    
    override func forward(sink: Sink) -> Source {
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