//
//  UIApplication.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/31.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UIApplication {
    var rNetworkActivityIndicatorVisible: KeyValueSink<Bool> {
        return rSink("networkActivityIndicatorVisible", as: Bool.self)
    }
}