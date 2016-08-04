//
//  UIBarItem.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/31.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UIBarItem {
    var rTitle: KeyValueSink<String?> {
        return rSink("title", as: (String?).self)
    }
    
    var rImage: KeyValueSink<UIImage?> {
        return rSink("image", as: (UIImage?).self)
    }
    
    var rEnabled: KeyValueSink<Bool> {
        return rSink("enabled", as: Bool.self)
    }
}