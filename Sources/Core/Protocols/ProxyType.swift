//
//  ProxyType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

protocol ProxyType: class {
    associatedtype Source: IntermediateType
    associatedtype Sink: IntermediateType
    
    var source: Source { get }
    var transform: (Sink.Element -> Void) -> (Source.Element -> Void) { get }
    var materialized: (Sink, Subscription<Source>)? { get set }
    
    init(source: Source, transform: (Sink.Element -> Void) -> (Source.Element -> Void))
}

extension ProxyType {
    func _materialize() -> (Sink, Subscription<Source>) {
        if let materialized = self.materialized {
            return materialized
        }
        
        let sink = Sink()
        let subscription = sink.connect(to: source, transform: transform)
        let materialized = (sink, subscription)
        self.materialized = materialized
        return materialized
    }
    
    func _subscribe(observer: Sink.Element -> Void) -> Relationship<Source, Sink> {
        let (sink, subscription1) = _materialize()
        let subscription2 = sink.subscribe(observer)
        
        return Relationship(intermediate1: source, intermediate2: sink) { _ in
            subscription1.dispose()
            subscription2.dispose()
        }
    }
    
    func map<Proxy: ProxyType where Proxy.Source == Source>(transform: IO<Sink.Element, Proxy.Sink.Element>.Raw) -> Proxy {
        return Proxy(source: source, transform: transform ∘ self.transform)
    }
}