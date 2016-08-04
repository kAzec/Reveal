//
//  UIPageControl.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/4.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UIPageControl {
    var rCurrentPage: KeyValueSink<Int> {
        return rSink("currentPage", as: Int.self)
    }
}