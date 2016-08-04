//
//  IntermediateType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/12.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - IntermediateType
public protocol IntermediateType: SourceType, SinkType, CustomStringConvertible {
    var subject: Subject<Element> { get }
}

public extension IntermediateType {
    var name: String {
        return subject.lock.name!
    }
    
    var description: String {
        return "[\(Self.self) - \(name)]"
    }
}

public protocol BaseIntermediateType: IntermediateType, Disposable {
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
    
    var disposed: Bool {
        return subject.disposed.boolValue
    }
}