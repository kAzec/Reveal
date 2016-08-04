//
//  UIButton.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UIButton {
    var rTitle: ObjectSink<UIButton, String?> {
        return rSink((String?).self) { button, title in
            button.setTitle(title, forState: .Normal)
        }
    }
    
    func rTap() -> Stream<Void> {
        return (rControlEvents(.TouchUpInside) |> map { _ in }).stream
    }
}