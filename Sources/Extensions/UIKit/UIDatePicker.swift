//
//  UIDatePicker.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UIDatePicker {
    var rDate: Property<NSDate> {
        return rControlEventProperty("date", initial: date, events: .ValueChanged,
            getter: { $0.date },
            setter: { $0.setDate($1, animated: true) }
        )
    }
    
    func rDateSink(animated: Bool = true) -> ObjectSink<UIDatePicker, NSDate> {
        return rSink(NSDate.self) { datePicker, date in
            datePicker.setDate(date, animated: animated)
        }
    }
}