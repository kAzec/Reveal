//
//  UIView.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UIView {
    var rAlpha: KeyValueSink<CGFloat> {
        return rSink("alpha", as: CGFloat.self)
    }
    
    var rBackgroundColor: KeyValueSink<UIColor?> {
        return rSink("backgroundColor", as: (UIColor?).self)
    }
    
    var rHidden: KeyValueSink<Bool> {
        return rSink("hidden", as: Bool.self)
    }
    
    var rUserInteractionEnabled: KeyValueSink<Bool> {
        return rSink("userInteractionEnabled", as: Bool.self)
    }
    
    var rTintColor: KeyValueSink<UIColor?> {
        return rSink("tintColor", as: (UIColor?).self)
    }
}