//
//  UISlider.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UISlider {
    var rValue: Property<Float> {
        return rControlEventProperty("value", initial: value, events: .ValueChanged,
            getter: { $0.value },
            setter: { $0.setValue($1, animated: true) }
        )
    }
    
    func rValueSink(animated: Bool = true) -> ObjectSink<UISlider, Float> {
        return rSink(Float.self) { slider, value in
            slider.setValue(value, animated: animated)
        }
    }
}