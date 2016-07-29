//
//  TakeWhile.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class TakeWhile<Element>: ControlWithPredicate<Element> {
    override init(_ predicate: Element -> Bool) {
        super.init(predicate)
    }
    
    override var exceptation: Bool {
        return true
    }
    
    override var onPredicateFailure: (Void -> Void)? {
        return completionSink
    }
}