//
//  OperatorType.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/16.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

protocol OperatorType: class {
    associatedtype Input
    associatedtype Output
    
    func forward(sink: Output -> Void) -> (Input -> Void)
}