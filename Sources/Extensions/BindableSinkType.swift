//
//  BindableSinkType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/4.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public protocol BindableSinkType: SinkType {  }

public extension SourceType {
    func bind<Sink: BindableSinkType>(to sink: Sink, transform: Element -> Sink.Element?) -> Disposable {
        return sink.subscribed { observer in
            return subscribe { element in
                if let value = transform(element) {
                    observer(value)
                }
            }
        } ?? BooleanDisposable(disposed: true)
    }
    
    func bind<Sink: BindableSinkType where Sink.Element == Element>(to sink: Sink) -> Disposable {
        return bind(to: sink, transform: id)
    }
}

public extension SourceType where Element: EventType {
    func bind<Sink: BindableSinkType where Sink.Element == Element.Value>(to sink: Sink) -> Disposable {
        return bind(to: sink, transform: { $0.next })
    }
}

public func ~>><Source: SourceType, Sink: BindableSinkType where Source.Element == Sink.Element>(lhs: Source, rhs: Sink) -> Disposable {
    return lhs.bind(to: rhs)
}

public func ~>><Source: SourceType, Sink: BindableSinkType where Source.Element: EventType, Source.Element.Value == Sink.Element>(lhs: Source, rhs: Sink) -> Disposable {
    return lhs.bind(to: rhs)
}