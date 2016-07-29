//
//  DisposableCollector.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/25.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class DisposableCollector: Disposable {
    private let compositeDisposable = CompositeDisposable()
   
    public var disposed: Bool {
        return compositeDisposable.disposed
    }
    
    public init() {  }
    
    public func collect(disposable: Disposable) {
        compositeDisposable.append(disposable)
    }
    
    public func collect<S: SequenceType where S.Generator.Element == Disposable>(disposables: S) {
        compositeDisposable.append(disposables)
    }
    
    public func dispose() {
        compositeDisposable.dispose()
    }
    
    deinit {
        compositeDisposable.dispose()
    }
}

public protocol DisposableCollectorOwnerType {
    var disposableCollector: DisposableCollector { get }
}

public extension Disposable {
    func dispose(in collector: DisposableCollector) {
        collector.collect(self)
    }
    
    func dispose<Owner: DisposableCollectorOwnerType>(in collectorOwner: Owner) {
        collectorOwner.disposableCollector.collect(self)
    }
}