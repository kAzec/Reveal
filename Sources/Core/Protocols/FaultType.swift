//
//  FaultType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/13.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public protocol FaultType: IntermediateOwnerType {
    associatedtype Source: BaseIntermediateType
    associatedtype Result: BaseIntermediateType = Owned
    
    init(source: Source, forwarder: (Result.Element -> Void) -> (Source.Element -> Void))
}