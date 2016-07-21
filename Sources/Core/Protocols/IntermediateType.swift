//
//  IntermediateType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/12.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public protocol IntermediateType: SourceType, SinkType, Disposable {
    var repository: Repository<Element> { get }
    
    init(_ name: String)
}

public extension IntermediateType {
    init() {
        self.init(String(Self))
    }
    
    init(name: String? = nil, @noescape observee: (Element -> Void) -> Disposable?) {
        self.init(name ?? String(Self))
        subscribed(by: observee)
    }
}