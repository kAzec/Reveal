//
//  UISegementControl.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UISegmentedControl {
    var rSelectedSegementIndex: KeyValueSink<Int> {
        return rSink("selectedSegementIndex", as: Int.self)
    }
}