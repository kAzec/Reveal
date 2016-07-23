//
//  DistinctLatest.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class DistinctLatest<T>: ValueCustomOperator<T, T> {
    private var latest: T?
    
    private let predicate: (latest: T, value: T) -> Bool
    
    init(_ predicate: (T, T) -> Bool) {
        self.predicate = predicate
    }
    
    override func forward(sink: T -> Void) -> (T -> Void) {
        return { value in
            if self.latest == nil || self.predicate(latest: self.latest!, value: value) {
                self.latest = value
                sink(value)
            }
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next nextSink: T -> Void) -> (Void -> Void) {
        return {
            self.latest = nil
            completionSink()
        }
    }
}