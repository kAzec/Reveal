//
//  ObjectSink.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/3.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public struct ObjectSink<Object: NSObject, Value>: BindableSinkType {
    private weak var object: Object?
    private let setter: (Object, Value) -> Void
    
    public init(object: Object, setter: (Object, Value) -> Void) {
        self.object = object
        self.setter = setter
    }
    
    public func subscribed(@noescape by observee: (Value -> Void) -> Disposable?) {
        guard object != nil else { return }
        
        let setter = self.setter
        observee { [weak object] newValue in
            guard let object = object else { return }
            setter(object, newValue)
        }
    }
}