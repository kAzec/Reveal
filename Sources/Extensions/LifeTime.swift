//
//  LifeTime.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public final class LifeTime: SourceType {
    private let node: Node<Void>
    
    init(_ name: String) {
        node = Node(name)
    }
    
    deinit {
        node.on(())
    }
    
    public func subscribe(observer: Void -> Void) -> Disposable {
        return node.subscribe(observer)
    }
}