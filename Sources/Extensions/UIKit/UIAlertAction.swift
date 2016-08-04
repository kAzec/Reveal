//
//  UIAlertAction.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/4.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UIAlertAction {
    var rEnabled: KeyValueSink<Bool> {
        return rSink("enabled", as: Bool.self)
    }
}