//
//  Result.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/14.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public enum Result<Value, Error: ErrorType> {
    case success(Value)
    case failure(Error)
}