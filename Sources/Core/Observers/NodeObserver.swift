//
//  NodeObserver.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public struct NodeObserver<Value> {
    public typealias Action = Value -> Void
    
    let action: Action
    
    public init(_ action: Action) {
        self.action = action
    }
    
    public func next(element: Value) {
        action(element)
    }
}

public extension Node {
    typealias Observer = NodeObserver<Value>
    
    class func pipe() -> (Node, Observer) {
        var observer: Observer!
        let node = Node { action in
            observer = Observer(action)
            return nil
        }
        
        return (node, observer)
    }
}