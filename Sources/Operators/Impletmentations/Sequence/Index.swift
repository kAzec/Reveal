//
//  Index.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Index<T>: ValueCustomOperator<T, (index: Int, value: T)> {
    typealias Indexed = (index: Int, value: T)
    
    private var currentIndex: Int = -1
    
    override func forward(sink: Sink) -> Source {
        return { value in
            self.currentIndex += 1
            let indexed = (self.currentIndex, value)
            sink(indexed)
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void) {
        return {
            self.currentIndex = -1
            completionSink()
        }
    }
}