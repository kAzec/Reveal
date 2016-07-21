//
//  Sink.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public protocol SinkType: class {
    associatedtype Element
    
    func subscribed(@noescape by observee: (Element -> Void) -> Disposable?)
}

public extension SinkType {
    func connect<S: SourceType where S.Element == Element>(to source: S) -> Subscription<S> {
        return connect(to: source, transform: identity)
    }
    
    func connect<S: SourceType>(to source: S, @noescape transform: (Element -> Void) -> (S.Element -> Void)) -> Subscription<S> {
        var subscription: Subscription<S>!
        
        subscribed { observer in
            subscription = source.subscribe(transform(observer))
            return subscription
        }
        
        return subscription
    }
}