//
//  UISwitch.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UISwitch {
    var rOn: Property<Bool> {
        return rControlEventProperty("on", initial: on, events: .ValueChanged,
            getter: { $0.on },
            setter: { $0.setOn($1, animated: true) }
        )
    }
    
    func rOnSink(animated: Bool = true) -> ObjectSink<UISwitch, Bool> {
        return rSink(Bool.self) {
            $0.setOn($1, animated: animated)
        }
    }
}