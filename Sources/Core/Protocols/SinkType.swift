//
//  Sink.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/11.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public protocol SinkType {
    associatedtype Element
    
    func subscribed(@noescape by observee: (Element -> Void) -> Disposable?)
}