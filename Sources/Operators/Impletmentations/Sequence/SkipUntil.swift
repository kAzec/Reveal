//
//  SkipUntil.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/9.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class SkipUntil<T, Trigger: SourceType>: ControlWithTrigger<T, Trigger> {
    override init(_ trigger: Trigger, predicate: (Trigger.Element -> Bool)?) {
        super.init(trigger, predicate: predicate)
    }
    
    override var exceptation: Bool {
        return true
    }
}