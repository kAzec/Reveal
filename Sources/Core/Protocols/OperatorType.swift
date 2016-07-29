//
//  OperatorType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public protocol OperatorType: class {
    associatedtype I
    associatedtype O
    
    func forward(sink: O -> Void) -> (I -> Void)
}