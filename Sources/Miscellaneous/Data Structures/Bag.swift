//
//  Bag.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/12.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public struct Bag<Element> {
    public typealias RemovalToken = UInt
    
    private var elements: ContiguousArray<Element>
    private var tokens: ContiguousArray<RemovalToken> = []
    
    private var currentToken: UInt = 0
    
    public init() {
        elements = []
    }
    
    public init<S: SequenceType where S.Generator.Element == Element>(_ sequence: S) {
        elements = ContiguousArray(sequence)
        currentToken = UInt(elements.count)
        tokens = ContiguousArray(0..<currentToken)
    }
    
    public mutating func append(element: Element) -> RemovalToken {
        let token = currentToken
        
        tokens.append(token)
        elements.append(element)
        
        currentToken += 1
        return token
    }
    
    public mutating func remove(for token: RemovalToken) -> Element? {
        let count = tokens.count
        let first = tokens[0]
        let last = tokens[count - 1]
        guard token <= last && token >= first else { return nil }
        
        var removalIndex: Int
        
        if first == last {
            removalIndex = 0
        } else {
            removalIndex = Int((UInt(count - 1)) * (token - first) / (last - first))
            
            let middle = tokens[removalIndex]
            
            if token > middle {
                repeat {
                    removalIndex += 1
                } while token > tokens[removalIndex]
            } else if token < middle {
                repeat {
                    removalIndex -= 1
                } while token < tokens[removalIndex]
            }
        }
        
        if tokens[removalIndex] == token {
            tokens.removeAtIndex(removalIndex)
            return elements.removeAtIndex(removalIndex)
        } else {
            return nil
        }
    }
}

extension Bag: CollectionType {
    public typealias Index = Array<Element>.Index
    
    public var startIndex: Index {
        return elements.startIndex
    }
    
    public var endIndex: Index {
        return elements.endIndex
    }
    
    public subscript(index: Index) -> Element {
        return elements[index]
    }
}