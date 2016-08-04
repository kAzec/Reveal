//
//  UIRefreshControl.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

public extension UIRefreshControl {
    var rRefreshing: Property<Bool> {
        return rControlEventProperty("refreshing", initial: self.refreshing, events: .ValueChanged,
            getter: { $0.refreshing },
            setter: UIRefreshControl.setRefreshing
        )
    }
    
    var rRefreshingSink: ObjectSink<UIRefreshControl, Bool> {
        return rSink(Bool.self, setter: UIRefreshControl.setRefreshing)
    }
    
    private class func setRefreshing(control: UIRefreshControl, refreshing: Bool) {
        if refreshing {
            control.beginRefreshing()
        } else {
            control.endRefreshing()
        }
    }
}