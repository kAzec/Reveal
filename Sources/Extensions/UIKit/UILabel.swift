//
//  UILabel.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/31.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UILabel {
    var rText: KeyValueSink<String?> {
        return rSink("text", as: (String?).self)
    }
    
    var rAttributedText: KeyValueSink<NSAttributedString?> {
        return rSink("attributedText", as: (NSAttributedString?).self)
    }
    
    var rTextColor: KeyValueSink<UIColor?> {
        return rSink("textColor", as: (UIColor?).self)
    }
}