//
//  StreamProxy.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class StreamProxy<I, O>: ProxyType {
    typealias Transform = IO<Signal<I>, Signal<O>>.Raw
    
    let source: Stream<I>
    let transform: Transform
    var materialized: (Stream<O>, Subscription<Stream<I>>)?
    
    init(source: Stream<I>, transform: Transform) {
        self.source = source
        self.transform = transform
    }
    
    public func materialize() -> (stream: Stream<O>, subscription: Subscription<Stream<I>>) {
        return _materialize()
    }
    
    public func stream() -> Stream<O> {
        return _materialize().0
    }
    
    public func subscribe(observer: Stream<O>.Action) -> Relationship<Stream<I>, Stream<O>> {
        return _subscribe(observer)
    }
}