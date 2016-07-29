//
//  IntermediateType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/12.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - IntermediateType
public protocol IntermediateType: SourceType, SinkType, Disposable {
    var subject: Subject<Element> { get }
}

public extension IntermediateType {
    var name: String {
        return subject.lock.name!
    }
    
    var disposed: Bool {
        return subject.disposed.boolValue
    }
}

public protocol BaseIntermediateType: IntermediateType {
    init(_ name: String)
}

public extension BaseIntermediateType {
    init() {
        self.init(String(Self))
    }
    
    init(_ name: String? = nil, @noescape observee: (Element -> Void) -> Disposable?) {
        self.init(name ?? String(Self))
        subscribed(by: observee)
    }
}

public protocol IntermediateOwnerType: IntermediateType {
    associatedtype Owned: IntermediateType
    
    var intermediate: Owned { get }
}

public extension IntermediateOwnerType {
    typealias Element = Owned.Element
    
    var subject: Subject<Owned.Element> {
        return intermediate.subject
    }
    
    func subscribe(observer: Owned.Element -> Void) -> Disposable {
        return intermediate.subscribe(observer)
    }
    
    func subscribed(@noescape by observee: (Owned.Element -> Void) -> Disposable?) {
        intermediate.subscribed(by: observee)
    }
    
    func dispose() {
        intermediate.dispose()
    }
}

// MARK: - NodeType
public protocol NodeType: IntermediateType {
    associatedtype Value
    
    var node: Node<Value> { get }
    
    func producer() -> NodeProducer<Value>
}

public extension NodeType {
    typealias Element = Value
    
    func producer() -> NodeProducer<Value> {
        return NodeProducer.of(self)
    }
}

// MARK: - StreamType
public protocol StreamType: IntermediateType {
    associatedtype Value
    
    var stream: Stream<Value> { get }
    
    func producer() -> StreamProducer<Value>
}

public extension StreamType {
    typealias Element = Signal<Value>
    
    func producer() -> StreamProducer<Value> {
        return StreamProducer.of(self)
    }
}

// MARK: - OperationType
public protocol OperationType: IntermediateType {
    associatedtype Value
    associatedtype Error: ErrorType
    
    var operation: Operation<Value, Error> { get }
    
    func producer() -> OperationProducer<Value, Error>
}

public extension OperationType {
    typealias Element = Response<Value, Error>
    
    func producer() -> OperationProducer<Value, Error> {
        return OperationProducer.of(self)
    }
}