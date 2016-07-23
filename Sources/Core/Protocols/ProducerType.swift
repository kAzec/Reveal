//
//  ProducerType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/12.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

protocol ProducerType: class {
    associatedtype Target: IntermediateType
    
    var anonymousObservee: (Target.Element -> Void) -> Disposable? { get }
    
    init(_ observee: (Target.Element -> Void) -> Disposable?)
}

extension ProducerType {
    static func create(observee: (Target.Element -> Void) -> Disposable?) -> Self {
        return self.init(observee)
    }
    
    static func create<Source: SourceType where Source.Element == Target.Element>(source source: Source) -> Self {
        return self.init { observer in
            return source.subscribe(observer)
        }
    }
    
    static func create<Source: SourceType>(source source: Source, transform: Source.Element -> Target.Element) -> Self {
        return self.init { observer in
            return source.subscribe(transform ∘ observer)
        }
    }
    
    static func create(element element: Target.Element) -> Self {
        return self.init { observer in
            observer(element)
            return nil
        }
    }
    
    static func create<Sequence: SequenceType where Sequence.Generator.Element == Target.Element>(sequence sequence: Sequence) -> Self {
        return self.init { observer in
            for element in sequence {
                observer(element)
            }
            return nil
        }
    }
}

extension ProducerType {
    func map<P: ProducerType>(transform: IO<Target.Element, P.Target.Element>.Raw) -> P {
        return P(transform ∘ anonymousObservee)
    }
    
    func startWithTarget(@noescape setup: Target -> Void) {
        let product = Target()
        setup(product)
        
        if product.disposed { return }
        product.subscribed(by: anonymousObservee)
    }
    
    func startWithObserver(observer: Target.Element -> Void) -> Disposable {
        let product = Target()
        product.subscribe(observer)
        product.subscribed(by: anonymousObservee)
        
        return product
    }
    
    func start() -> Disposable {
        let product = Target()
        product.subscribed(by: anonymousObservee)
        return product
    }
}