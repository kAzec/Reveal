//
//  NSNotificationCenter.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public extension NSNotificationCenter {
    func rNotification(name: String? = nil, object: AnyObject? = nil) -> NodeProducer<NSNotification> {
        return NodeProducer { [weak object] observer, disposable in
            let subscription = NSNotificationCenter.defaultCenter().addObserverForName(name, object: object, queue: nil, usingBlock: observer)
            
            disposable += {
                NSNotificationCenter.defaultCenter().removeObserver(subscription)
            }
        }
    }
}