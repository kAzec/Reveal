//
//  ActiveType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/28.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - ActiveType
public protocol ActiveType: IntermediateOwnerType {
    init(_ name: String)
    func send(element: Owned.Element)
}

public extension ActiveType {
    init() {
        self.init(String(self.dynamicType))
    }
}

public extension ActiveType where Owned.Element: EventType {
    typealias Value = Owned.Element.Value
    
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

public extension ActiveType where Owned.Element: ErrorableEventType {
    typealias Error = Owned.Element.Error
    
    func sendFailure(error: Error) {
        send(.makeFailed(error))
    }
}
