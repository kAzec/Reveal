//
//  UIImageVIew.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UIImageView {
    var rImage: KeyValueSink<UIImage?> {
        return rSink("image", as: (UIImage?).self)
    }
}