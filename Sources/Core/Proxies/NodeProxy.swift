//
//  NodeProxy.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class NodeProxy<I, O>: ProxyType {
    typealias Transform = IO<Node<I>.Element, Node<O>.Element>.Raw
    
    let source: Node<I>
    let transform: Transform
    var materialized: (Node<O>, Subscription<Node<I>>)?
    
    init(source: Node<I>, transform: Transform) {
        self.source = source
        self.transform = transform
    }
    
    public func materialize() -> (node: Node<O>, subscription: Subscription<Node<I>>) {
        return _materialize()
    }
    
    public func node() -> Node<O> {
        return _materialize().0
    }
    
    public func subscribe(observer: Node<O>.Action) -> Relationship<Node<I>, Node<O>> {
        return _subscribe(observer)
    }
}