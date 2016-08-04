//
//  FaultType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

protocol FaultType: ProxyType {
    var observee: (Proxy.Element -> Void) -> Disposable { get }
    var lazy: Box<(Proxy, Disposable)?> { get }
    
    init(_ observee: (Proxy.Element -> Void) -> Disposable)
}

extension FaultType {
    init<U>(_ observee: (U -> Void) -> Disposable, _ forwarder: IO<U, Proxy.Element>.A) {
        self.init(compose(forwarder, observee))
    }
    
    func fire() -> (Proxy, Disposable) {
        if let evaluated = lazy.value {
            return evaluated
        }
        
        let proxy = Proxy()
        let subscription = proxy.subscribed(by: observee)!
        
        let evaluated = (proxy, subscription)
        lazy.value = evaluated
        return evaluated
    }
    
    func lift<Fault: FaultType>(forwarder: IO<Proxy.Element, Fault.Proxy.Element>.A) -> Fault {
        return Fault(observee, forwarder)
    }
}

extension SourceType {
    func lift<Fault: FaultType>(forwarder: IO<Element, Fault.Proxy.Element>.A) -> Fault {
        return Fault(subscribe, forwarder)
    }
}