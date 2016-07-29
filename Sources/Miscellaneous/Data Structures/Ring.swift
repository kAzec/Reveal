//
//  Ring.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

struct Ring<Element> {
    let length: Int
    
    private var data: [Element]
    private var nextIndex: Int? = nil
    
    var count: Int {
        return data.count
    }
    
    var isFull: Bool {
        return nextIndex != nil
    }
    
    var willRemoveValue: Element? {
        return count < length ? nil : data[calcuateNextIndex()]
    }
    
    init(length: Int) {
        assert(length > 0, "Invalid length\(length)")
        
        self.length = length
        data = [Element]()
    }
    
    init(count: Int, repeatedValue: Element) {
        assert(count > 0, "Invalid length\(count)")
        
        length = count
        data = [Element](count: count, repeatedValue: repeatedValue)
    }
    
    mutating func enqueue(element: Element) -> Element? {
        if count < length {
            data.append(element)
            return nil
        } else {
            let nextIndex = calcuateNextIndex()
            let temp = data[nextIndex]
            data[nextIndex] = element
            self.nextIndex = nextIndex
            return temp
        }
    }
    
    mutating func removeAll(keepCapacity keep: Bool = false) {
        data.removeAll(keepCapacity: keep)
        nextIndex = nil
    }
    
    mutating func purgeAll(keepCapacity keep: Bool = false) -> [Element] {
        let array = Array(self)
        removeAll(keepCapacity: keep)
        return array
    }
    
    private func calcuateNextIndex() -> Int {
        let possibleIndex = nextIndex?.advancedBy(-1) ?? length - 1
        return possibleIndex >= 0 ? possibleIndex : length - 1
    }
}

extension Ring: CollectionType {
    var startIndex: Int {
        return data.startIndex
    }
    
    var endIndex: Int {
        return data.endIndex
    }
    
    subscript(index: Int) -> Element {
        if let nextIndex = nextIndex {
            let index = (nextIndex + index) % length
            return data[index]
        } else {
            return data[index]
        }
    }
}