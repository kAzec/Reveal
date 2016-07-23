//
//  TakeUntil.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/8.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class TakeUntil<T, Trigger: SourceType>: ControlWithTrigger<T, Trigger> {
    override init(_ trigger: Trigger, predicate isTriggerTerminating: (Trigger.Element -> Bool)?) {
        super.init(trigger, predicate: isTriggerTerminating)
    }
    
    override var exceptation: Bool {
        return true
    }
}