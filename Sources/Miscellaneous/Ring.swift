//
//  Ring.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/2.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

struct Ring<Element> {
    let capacity: Int
    
    private var datium: [Element]
    private var nextIndex: Int? = nil
    
    var count: Int {
        return datium.count
    }
    
    var isFull: Bool {
        return nextIndex != nil
    }
    
    var willRemoveValue: Element? {
        return count < capacity ? nil : datium[calcuateNextIndex()]
    }
    
    init(capacity: Int) {
        assert(capacity > 0, "expects capacity > 0 where capacity = \(capacity)")
        
        self.capacity = capacity
        datium = [Element]()
    }
    
    init(count: Int, repeatedValue: Element) {
        assert(count > 0, "expects count > 0 where count = \(count)")
        
        capacity = count
        datium = [Element](count: count, repeatedValue: repeatedValue)
    }
    
    private func calcuateNextIndex() -> Int {
        let possibleIndex = nextIndex?.advancedBy(-1) ?? capacity - 1
        return possibleIndex >= 0 ? possibleIndex : capacity - 1
    }
    
    mutating func enqueue(element: Element) -> Element? {
        if count < capacity {
            datium.append(element)
            return nil
        } else {
            let nextIndex = calcuateNextIndex()
            let temp = datium[nextIndex]
            datium[nextIndex] = element
            self.nextIndex = nextIndex
            return temp
        }
    }
    
    mutating func removeAll(keepCapacity keep: Bool = false) {
        datium.removeAll(keepCapacity: keep)
        nextIndex = nil
    }
    
    mutating func retriveAll(keepCapacity keep: Bool = false) -> [Element] {
        let array = Array(self)
        removeAll(keepCapacity: keep)
        return array
    }
}

extension Ring: ArrayLiteralConvertible {
    init(arrayLiteral elements: Element...) {
        let count = elements.count
        assert(count > 0, "expects count > 0 where count = \(count)")
        
        capacity = elements.count
        datium = elements
        nextIndex = capacity
    }
}

extension Ring: CustomStringConvertible {
    var description: String {
        return "[" + self.map{"\"\($0)\""}.joinWithSeparator(", ") + "]"
    }
}

extension Ring: CollectionType {
    init() {
        self.init(capacity: 1)
    }
    
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return datium.count
    }
    
    subscript(index: Int) -> Element {
        if let nextIndex = nextIndex {
            let index = (nextIndex + index) % capacity
            return datium[index]
        } else {
            return datium[index]
        }
    }
}