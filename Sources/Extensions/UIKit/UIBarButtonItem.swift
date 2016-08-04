//
//  UIBarButtonItem.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/31.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

private var UIBarButtonItemRevealHelperKey: Int32 = 0

public extension UIBarButtonItem {
    var rTap: Stream<Void> {
        return associatedObject(for: &UIBarButtonItemRevealHelperKey, initial: Helper(self)).stream
    }
    
    private class Helper: NSObject {
        weak var barButtonItem: UIBarButtonItem?
        let stream: Stream<Void>
        
        init(_ barButtonItem: UIBarButtonItem) {
            self.barButtonItem = barButtonItem
            stream = Stream("\(String(UIBarButtonItem)) - didTap")
            
            super.init()
            
            barButtonItem.target = self
            barButtonItem.action = #selector(Helper.on)
        }
        
        @objc func on() {
            stream.on(.next(()))
        }
        
        deinit {
            barButtonItem?.target = nil
            stream.on(.completed)
        }
    }
}
