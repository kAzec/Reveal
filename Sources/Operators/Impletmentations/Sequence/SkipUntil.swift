//
//  SkipUntil.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/9.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class SkipUntil<T, Trigger: SourceType>: ControlWithTrigger<T, Trigger> {
    override init(_ trigger: Trigger, predicate isTriggerTerminating: (Trigger.Element -> Bool)?) {
        super.init(trigger, predicate: isTriggerTerminating)
    }
    
    override var exceptation: Bool {
        return false
    }
}