//
//  CombinePrevious.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class CombinePrevious<T>: ValueCustomOperator<T, (previous: T, value: T)> {
    typealias Pair = (previous: T, value: T)
    
    private var previous: T?
    
    init(_ initial: T?) {
        previous = initial
    }
    
    override func forward(sink: Pair -> Void) -> (T -> Void) {
        return { value in
            if let previous = self.previous {
                let pair = (previous, value)
                self.previous = value
                sink(pair)
            }
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next nextSink: Pair -> Void) -> (Void -> Void) {
        return {
            self.previous = nil
            completionSink()
        }
    }
}

final class CombinePreviousCount<T>: ValueCustomOperator<T, (previous: [T], element: T)> {
    typealias Pair = (previous: [T], value: T)
    
    private var previous: Ring<T>
    
    init(_ maxCount: Int) {
        previous = Ring(capacity: maxCount)
    }
    
    override func forward(sink: Pair -> Void) -> (T -> Void) {
        return { value in
            if self.previous.isFull {
                let pair = (self.previous.retriveAll(), value)
                sink(pair)
            }
            
            self.previous.enqueue(value)
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next nextSink: Pair -> Void) -> (Void -> Void) {
        return {
            self.previous.removeAll()
            completionSink()
        }
    }
}