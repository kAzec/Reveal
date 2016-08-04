//
//  UIViewController.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/4.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UIViewController {
    var rTitle: KeyValueSink<String?> {
        return rSink("title", as: (String?).self)
    }
}