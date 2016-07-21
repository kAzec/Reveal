//
//  Collect.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class Collect<T>: SignalOperator<T, [T]> {
    private var collected = [T]()
    
    override func forward(sink: Signal<[T]>.Action) -> Signal<T>.Action {
        return { signal in
            switch signal {
            case .next(let element):
                self.collected.append(element)
            case .completed:
                sink(.next(self.collected))
                sink(.completed)
                self.collected.removeAll()
            }
        }
    }
}

final class CollectCount<T>: ValueCustomOperator<T, [T]> {
    private let countLimit: Int
    private var countCollected = 0
    private var collected = [T]()
    
    init(count: Int) {
        precondition(count > 0)
        
        countLimit = count
    }
    
    override func forward(sink: [T] -> Void) -> (T -> Void) {
        return { element in
            if self.collect(element) {
                sink(self.empty())
            }
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next nextSink: [T] -> Void) -> (Void -> Void) {
        return {
            nextSink(self.empty())
            completionSink()
        }
    }
    
    private func collect(element: T) -> Bool {
        collected.append(element)
        countCollected += 1
        return countCollected >= countLimit
    }
    
    private func empty() -> [T] {
        let temp = collected
        collected.removeAll()
        countCollected = 0
        return temp
    }
}