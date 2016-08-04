//
//  UIActivityIndicatorView.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/31.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UIActivityIndicatorView {
    var rAnimating: ObjectSink<UIActivityIndicatorView, Bool> {
        return rSink(Bool.self) { view, animating in
            if animating {
                self.startAnimating()
            } else {
                self.stopAnimating()
            }
        }
    }
}