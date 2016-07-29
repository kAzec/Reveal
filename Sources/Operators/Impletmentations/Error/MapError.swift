//
//  MapError.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/18.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class MapError<T, E: ErrorType, F: ErrorType>: ResponseOperator<T, E, T, F> {
    private let transform: E -> F
    
    init(_ transform: E -> F) {
        self.transform = transform
    }
    
    override func forward(sink: Sink) -> Source {
        return {
            $0.mapError(self.transform)
        }
    }
}