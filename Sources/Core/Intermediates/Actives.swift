//
//  Actives.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/25.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - Generic Active class
public class Active<Base: BaseIntermediateType>: ActiveType {
    public let intermediate: Base
    let sink: Base.Element -> Void
    
    public required init(_ name: String) {
        intermediate = Base(name)
        
        var sink: (Base.Element -> Void)!
        
        intermediate.subscribed {
            sink = $0
            return nil
        }
        
        self.sink = sink
    }
    
    public final func send(element: Base.Element) {
        sink(element)
    }
}

// MARK: - ActiveNode class
public final class ActiveNode<T>: Active<Node<T>>, NodeType {
    public var node: Node<T> {
        return intermediate
    }
    
    public required init(_ name: String) {
        super.init(name)
    }
}

// MARK: - ActiveStream class
public final class ActiveStream<T>: Active<Stream<T>>, StreamType {
    public var stream: Stream<T> {
        return intermediate
    }
    
    public required init(_ name: String) {
        super.init(name)
    }
}

// MARK: - ActiveOperation class
public final class ActiveOperation<T, E: ErrorType>: Active<Operation<T, E>>, OperationType {
    public var operation: Operation<T, E> {
        return intermediate
    }
    
    public required init(_ name: String) {
        super.init(name)
    }
}