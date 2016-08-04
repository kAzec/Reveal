//
//  KeyValueSink.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/3.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public struct KeyValueSink<Value>: BindableSinkType {
    private weak var object: NSObject?
    private let keyPath: String
    
    public init(object: NSObject, keyPath: String) {
        self.object = object
        self.keyPath = keyPath
    }
    
    public func subscribed(@noescape by observee: (Value -> Void) -> Disposable?) {
        guard object != nil else { return }
        
        let keyPath = self.keyPath
        observee { [weak object] newValue in
            guard let object = object else { return }
            object.setValue(newValue as? AnyObject, forKeyPath: keyPath)
        }
    }
}