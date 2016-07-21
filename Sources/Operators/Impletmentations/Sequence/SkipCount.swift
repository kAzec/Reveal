//
//  SkipCount.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class SkipCount<T>: ControlWithCount<T> {
    override init(_ count: Int) {
        super.init(count)
    }
    
    override func forward(sink: T -> Void) -> (T -> Void) {
        guard countLimit > 0 else { return sink }
        
        return { value in
            if self.controlValue {
                self.increment()
                return
            }
            
            sink(value)
        }
    }
}