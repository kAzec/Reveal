//
//  TakeCount.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class TakeCount<T>: ControlWithCount<T> {
    override init(_ count: Int) {
        super.init(count)
    }
    
    override func forward(sink: Sink) -> Source {
        guard limit > 0 else {
            completionSink?()
            return { _ in }
        }
        
        return { value in
            guard !self.exceeded else { return }
            
            self.increment()
            sink(value)
        }
    }
    
    override var onExceedingLimit: (Void -> Void)? {
        return completionSink
    }
}