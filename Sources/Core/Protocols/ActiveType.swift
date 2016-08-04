//
//  ActiveType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/28.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - ActiveType
public protocol ActiveType: ProxyType {
    associatedtype Proxy: BaseIntermediateType
    
    init(_ name: String)
    
    func send(element: Proxy.Element)
}

public extension ActiveType {
    init() {
        self.init(String(Self))
    }
}

public extension ActiveType where Proxy.Element: EventType {
    typealias Value = Proxy.Element.Value
    
    func sendNext(value: Value) {
        send(.makeNext(value))
    }
    
    func sendCompletion() {
        send(.makeCompleted())
    }
    
    public func sendLast(value: Value) {
        send(.makeNext(value))
        send(.makeCompleted())
    }
}

public extension ActiveType where Proxy.Element: ErrorableEventType {
    typealias Error = Proxy.Element.Error
    
    func sendFailure(error: Error) {
        send(.makeFailed(error))
    }
}
