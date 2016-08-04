//
//  UIStepper.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/4.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UIStepper {
    var rValue: Property<Double> {
        return rControlEventProperty("value", initial: value, events: .ValueChanged,
            getter: { $0.value },
            setter: { $0.value = $1 }
        )
    }
    
    var rValueSink: KeyValueSink<Double> {
        return rSink("value", as: Double.self)
    }
}