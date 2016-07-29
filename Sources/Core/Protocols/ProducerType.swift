//
//  ProducerType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/12.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public protocol ProducerType: SourceType {
    associatedtype Product: BaseIntermediateType
    
    init(_ producerHandler: ((Product.Element -> Void), CompositeDisposable) -> Void)
    
    func startWithProduct(@noescape setup: Product -> Void)
}

// MARK: - Public Extensions
public extension ProducerType {
    typealias Element = Product.Element
    
    static func of<Source: SourceType where Source.Element == Product.Element>(source: Source) -> Self {
        return self.init(source.subscribe)
    }
    
    static func never() -> Self {
        return self.init{ _ in }
    }
    
    func start(observer: (Product.Element -> Void)? = nil) -> Disposable {
        var product: Product!
        
        startWithProduct {
            product = $0
            if let observer = observer {
                product.subscribe(observer)
            }
        }
        
        return ScopedDisposable(product)
    }
    
    @available(*, unavailable, renamed="start", message="This method exists only to satisfy conformance to SourceType protocol.")
    func subscribe(observer: Product.Element -> Void) -> Disposable {
        return start(observer)
    }
    
    func prefix(with element: Product.Element) -> Self {
        return Self { observer, disposable in
            observer(element)
            
            disposable += self.start(observer)
        }
    }
    
    func restart(for times: Int, when shouldRestart: Product.Element -> Bool) -> Self {
        precondition(times >= 0)
        
        if times == 0 { return self }
        
        return Self { observer, disposable in
            let iterrationDisposable = SerialDisposable()
            disposable.append(iterrationDisposable)
            
            func iterate(current: Int) {
                iterrationDisposable.innerDisposable = self.start { element in
                    if shouldRestart(element) && current > 0 {
                        iterate(current - 1)
                    } else {
                        observer(element)
                    }
                }
            }
            
            iterate(times)
        }
    }
}

// MARK: ProducerType with EventType Element Extensions
public extension ProducerType where Product.Element: EventType {
    typealias Value = Product.Element.Value
    
    static func of<Source: SourceType where Source.Element == Value>(source: Source) -> Self {
        return self.init(apply(Product.Element.makeNext, to: source.subscribe))
    }
    
    static func of(value: Value) -> Self {
        return self.init { observer, _ in
            observer(.makeNext(value))
            observer(.makeCompleted())
        }
    }
    
    static func of<Sequence: SequenceType where Sequence.Generator.Element == Value>(values: Sequence) -> Self {
        return makeOfElements(first: nil, middle: values.map(Product.Element.makeNext), last: .makeCompleted())
    }
    
    static func of(first: Value, _ rest: Value...) -> Self {
        return makeOfElements(first: .makeNext(first), middle: rest.map(Product.Element.makeNext), last: .makeCompleted())
    }
    
    static func empty() -> Self {
        return makeOfElement(.makeCompleted())
    }
    
    func startWithNext(onNext: Value -> Void) -> Disposable {
        return start(Product.Element.observer(next: onNext))
    }
    
    func startWithCompleted(onCompletion: Void -> Void) -> Disposable {
        return start(Product.Element.observer(completion: onCompletion))
    }
    
    func suffix(with value: Value) -> Self {
        return Self { observer in
            return self.start { event in
                if event.completing {
                    observer(.makeNext(value))
                }
                
                observer(event)
            }
        }
    }
    
    func repeats(times: Int) -> Self {
        if times == 0 { return .empty() }
        
        return restart(for: times - 1) { $0.completing }
    }
}

// MARK: ProducerType with ErrorableEventType Element Extensions
// See OperationProducer.swift

// MARK: - Internal Extensions
extension ProducerType {
    static func makeOfElement(element: Product.Element) -> Self {
        return self.init { observer, _ in
            observer(element)
        }
    }
    
    static func makeOfElements<S: SequenceType where S.Generator.Element == Product.Element>(first first: Product.Element?, middle: S, last: Product.Element?) -> Self {
        return self.init { observer, disposable in
            if let first = first {
                observer(first)
            }
            
            if disposable.disposed { return }
            
            for element in middle {
                observer(element)
                
                if disposable.disposed { return }
            }
            
            if let last = last {
                observer(last)
            }
        }
    }
    
    init<T>(_ producerHandler: ((T -> Void), CompositeDisposable) -> Void, _ forwarder: IO<T, Product.Element>.Raw) {
        self.init { observer, disposable in
            producerHandler(forwarder(observer), disposable)
        }
    }
    
    init(_ observee: (Product.Element -> Void) -> Disposable) {
        self.init { observer, disposable in
            disposable += observee(observer)
        }
    }
    
    func startWithProduct(@noescape setup: Product -> Void, producerHandler: ((Product.Element -> Void), CompositeDisposable) -> Void) {
        let product = Product()
        setup(product)
        
        if product.disposed { return }
        
        product.subscribed { observer in
            producerHandler(observer, product.subject.disposables)
            return nil
        }
    }
    
    func firstElement() -> Product.Element {
        var element: Product.Element!
        
        let semaphore = dispatch_semaphore_create(0)
        
        startWithProduct { product in
            let disposable = ScopedDisposable(product)
            
            product.subscribe {
                element = $0
                dispatch_semaphore_signal(semaphore)
                disposable.dispose()
            }
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return element
    }
    
    func makeProduct() -> Product {
        var product: Product!
        
        startWithProduct {
            product = $0
        }
        
        return product
    }
}