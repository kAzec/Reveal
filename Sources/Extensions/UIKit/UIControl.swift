//
//  UIControl.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/31.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

private var UIControlHelpersKey: Int32 = 0

public extension UIControl {
    var rEnabled: KeyValueSink<Bool> {
        return rSink("enabled", as: Bool.self)
    }
    
    var rSelected: KeyValueSink<Bool> {
        return rSink("selected", as: Bool.self)
    }
    
    var rHighlighted: KeyValueSink<Bool> {
        return rSink("highlighted", as: Bool.self)
    }
    
    func rControlEvents(events: UIControlEvents = .AllEvents) -> Stream<UIControlEvents> {
        let helpers = associatedObject(for: &UIControlHelpersKey, initial: NSMutableArray())
        
        for helper in helpers {
            let helper = helper as! Helper
            if helper.events == events {
                return helper.stream
            }
        }
        
        let newHelper = Helper(self, events)
        helpers.addObject(newHelper)
        
        return newHelper.stream
    }
    
    private class Helper: NSObject {
        weak var control: UIControl?
        let stream: Stream<UIControlEvents>
        let events: UIControlEvents
        
        init(_ control: UIControl, _ events: UIControlEvents) {
            self.control = control
            self.events = events
            stream = Stream("\(control.dynamicType) - controlEvents")
            
            super.init()
            
            control.addTarget(self, action: #selector(Helper.on), forControlEvents: events)
        }
        
        @objc func on(sender: UIButton, events: UIControlEvents) {
            stream.on(.next(events))
        }
        
        deinit {
            control?.removeTarget(self, action: nil, forControlEvents: events)
            stream.on(.completed)
        }
    }
}

extension NSObjectProtocol where Self: UIControl {
    func rControlEventProperty<T>(key: String, initial: T, events: UIControlEvents, getter: Self -> T, setter: (Self, T) -> Void) -> Property<T> {
        return rAssociatedProperty(key, initial: initial, setter: setter) { (property: Property<T>) in
            rControlEvents(events).subscribeNext { [unowned property, weak self] _ in
                guard let weakSelf = self else { return }
                property.value = getter(weakSelf)
            }.dispose(with: self)
        }
    }
}