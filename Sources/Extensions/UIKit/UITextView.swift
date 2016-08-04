//
//  UITextView.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UITextView {
    var rText: Property<String> {
        return rAssociatedProperty("text", initial: text,
            setter: { textView, text in
                if textView.text != text {
                    textView.text = text
                }
            }, updater: { (property: Property<String>) in
                NSNotificationCenter.defaultCenter()
                    .rNotification(UITextViewTextDidChangeNotification, object: self)
                    .start { [weak property] notification in
                        if let property = property, textView = notification.object as? UITextView {
                            property.value = textView.text
                        }
                }.dispose(with: self)
        })
    }
}