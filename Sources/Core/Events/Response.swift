//
//  Response.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/3/31.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public enum Response<T, E: ErrorType>: ErrorableEventType {
    public typealias Value = T
    public typealias Error = E
    
    case next(Value)
    case failed(Error)
    case completed
}

public extension Response {
    typealias Action = Response -> Void
    
    var next: Value? {
        if case .next(let next) = self {
            return next
        } else {
            return nil
        }
    }
    
    var failure: Error? {
        if case .failed(let error) = self {
            return error
        } else {
            return nil
        }
    }
    
    var failing: Bool {
        if case .failed = self {
            return true
        } else {
            return false
        }
    }
    
    var completing: Bool {
        if case .completed = self {
            return true
        } else {
            return false
        }
    }
    
    var terminating: Bool {
        if case .next = self {
            return false
        } else {
            return true
        }
    }
    
    func map<U>(@noescape transform: Value -> U) -> Response<U, Error> {
        switch self {
        case .next(let value):
            return .next(transform(value))
        case .failed(let error):
            return .failed(error)
        case .completed:
            return .completed
        }
    }
    
    func mapError<F: ErrorType>(@noescape transform: Error -> F) -> Response<Value, F> {
        switch self {
        case .next(let value):
            return .next(value)
        case .failed(let error):
            return .failed(transform(error))
        case .completed:
            return .completed
        }
    }
}

public extension Response {
    static func makeNext(value: Value) -> Response {
        return .next(value)
    }
    
    static func makeFailed(error: Error) -> Response {
        return .failed(error)
    }
    
    static func makeCompleted() -> Response {
        return .completed
    }
}