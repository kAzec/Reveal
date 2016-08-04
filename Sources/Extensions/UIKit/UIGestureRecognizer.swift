//
//  UIGestureRecognizer.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/4.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import UIKit

private var UIGestureRecognizerTargetKey: Int32 = 0

public extension NSObjectProtocol where Self: UIGestureRecognizer {
    var rEvent: Stream<Self> {
        return associatedObject(for: &UIGestureRecognizerTargetKey, initial: UIGestureRecognizerTarget(self)).stream
    }
}

private class UIGestureRecognizerTarget<GestureRecognizer: UIGestureRecognizer> {
    weak var gestureRecognizer: GestureRecognizer?
    let stream: Stream<GestureRecognizer>
    
    init(_ gestureRecognizer: GestureRecognizer) {
        self.gestureRecognizer = gestureRecognizer
        stream = Stream(String(GestureRecognizer))
        
        let selector = #selector(UIGestureRecognizerTarget.on)
        gestureRecognizer.addTarget(self, action: selector)
        
        stream.subject.disposables += { [unowned self] in
            guard let gestureRecognizer = self.gestureRecognizer else { return }
            gestureRecognizer.removeTarget(self, action: selector)
        }
    }
    
    deinit {
        stream.dispose()
    }
    
    @objc func on(sender: AnyObject?) {
        stream.on(.next(gestureRecognizer!))
    }
}