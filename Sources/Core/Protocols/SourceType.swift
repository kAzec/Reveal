//
//  SourceType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public protocol SourceType {
    associatedtype Element
    
    func subscribe(observer: Element -> Void) -> Disposable
}

public extension SourceType {
    typealias Action = Element -> Void
}

public extension SourceType where Element: EventType {
    func subscribeNext(onNext: Element.Value -> Void) -> Disposable {
        return subscribe(Element.observer(next: onNext))
    }
    
    func subscribeCompleted(onCompletion: Void -> Void) -> Disposable {
        return subscribe(Element.observer(completion: onCompletion))
    }
}

public extension SourceType where Element: ErrorableEventType {
    func subscribeFailed(onFailure: Element.Error -> Void) -> Disposable {
        return subscribe(Element.observer(failure: onFailure))
    }
}