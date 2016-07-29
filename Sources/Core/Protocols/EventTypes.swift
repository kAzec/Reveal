//
//  EventTypes.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/25.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public protocol EventType {
    associatedtype Value
    
    var next: Value? { get }
    var completing: Bool { get }
    
    static func makeNext(value: Value) -> Self
    static func makeCompleted() -> Self
}

public protocol ErrorableEventType: EventType {
    associatedtype Error: ErrorType
    
    var failure: Error? { get }
    var failing: Bool { get }
    
    static func makeFailed(error: Error) -> Self
}

// MARK: - Event Transformations.
extension ErrorableEventType {
    static func makeWithEvent<E: EventType where E.Value == Value>(event: E) -> Self {
        if let value = event.next {
            return .makeNext(value)
        } else {
            return .makeCompleted()
        }
    }
    
    static func makeWithEvent<E: ErrorableEventType where E.Value == Value, E.Error == Error>(event: E) -> Self {
        if let value = event.next {
            return .makeNext(value)
        } else if let error = event.failure {
            return .makeFailed(error)
        } else {
            return .makeCompleted()
        }
    }
}

// MARK: - Event Observer Creations.
extension EventType {
    static func observer(next onNext: Value -> Void) -> (Self -> Void) {
        return { event in
            if let value = event.next {
                onNext(value)
            }
        }
    }
    
    static func observer(completion onCompletion: Void -> Void) -> (Self -> Void) {
        return { event in
            if event.completing {
                onCompletion()
            }
        }
    }
}

extension ErrorableEventType {
    static func observer(failure onFailure: Error -> Void) -> (Self -> Void) {
        return { event in
            if let error = event.failure {
                onFailure(error)
            }
        }
    }
}