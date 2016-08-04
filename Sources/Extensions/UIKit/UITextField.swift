//
//  UITextField.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UITextField {
    var rText: Property<String> {
        return rControlEventProperty("text", initial: self.text ?? "", events: .EditingChanged,
            getter: { textField in
                return textField.text ?? ""
            }, setter: { textField, text in
                if textField.text != text {
                    textField.text = text
                }
        })
    }
}