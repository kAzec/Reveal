//
//  Distinct.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Distinct<T: Hashable>: ValueCustomOperator<T, T> {
    private var hashed = Set<Int>()
    
    override init() {  }
    
    override func forward(sink: T -> Void) -> (T -> Void) {
        return { value in
            let hash = value.hashValue
            
            if !self.hashed.contains(hash) {
                self.hashed.insert(hash)
                sink(value)
            }
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next nextSink: T -> Void) -> (Void -> Void) {
        return {
            self.hashed.removeAll()
            completionSink()
        }
    }
}