//
//  SourceType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public protocol SourceType: class {
    associatedtype Element
    
    func subscribe(observer: Element -> Void) -> Subscription<Self>
}

public extension SourceType {
    func connected<S: SinkType where S.Element == Element>(by sink: S) -> Subscription<Self> {
        return sink.connect(to: self)
    }
    
    func connected<S: SinkType>(by sink: S, transform: (S.Element -> Void) -> (Element -> Void)) -> Subscription<Self> {
        return sink.connect(to: self, transform: transform)
    }
}