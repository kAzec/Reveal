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
    
    override func forward(sink: T -> Void) -> (T -> Void) {
        guard countLimit > 0 else { return { [sink] _ in let _ = sink } }
        
        return { value in
            guard self.controlValue else { return }
            self.increment()
            sink(value)
        }
    }
}