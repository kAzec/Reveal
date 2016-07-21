//
//  Bag.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/12.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

struct Bag<Element> {
    typealias Token = UInt
    typealias Elements = (value: Element, token: UInt)
    
    private var elements: ContiguousArray<Element>
    private var tokens: ContiguousArray<Token> = []
    
    private var currentToken: UInt = 0
    
    init() {
        elements = []
    }
    
    init<S: SequenceType where S.Generator.Element == Element>(_ sequence: S) {
        elements = ContiguousArray(sequence)
        currentToken = UInt(elements.count)
        tokens = ContiguousArray(0..<currentToken)
    }
    
    mutating func append(element: Element) -> Token {
        let token = currentToken
        
        tokens.append(token)
        elements.append(element)
        
        currentToken += 1
        return token
    }
    
    mutating func remove(for token: Token) {
        let count = tokens.count
        let first = tokens[0]
        let last = tokens[count - 1]
        guard token <= last && token >= first else { return }
        
        var removalIndex: Int
        
        if first == last {
            removalIndex = Int(first)
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
            elements.removeAtIndex(removalIndex)
            tokens.removeAtIndex(removalIndex)
        }
    }
}

extension Bag: CollectionType {
    typealias Index = Array<Element>.Index
    
    var startIndex: Index {
        return elements.startIndex
    }
    
    var endIndex: Index {
        return elements.endIndex
    }
    
    subscript(index: Index) -> Element {
        return elements[index]
    }
}