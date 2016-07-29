//
//  TryMap.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/18.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class TryMap<IV, OV, E: ErrorType>: ResponseOperator<IV, E, OV, E> {
    private let transform: IV -> Result<OV, E>
    
    init(_ transform: IV -> Result<OV, E>) {
        self.transform = transform
    }
    
    override func forward(sink: Sink) -> Source {
        return { response in
            switch response {
            case .next(let element):
                switch self.transform(element) {
                case .success(let element):
                    sink(.next(element))
                case .failure(let error):
                    sink(.failed(error))
                }
            case .failed(let error):
                sink(.failed(error))
            case .completed:
                sink(.completed)
            }
        }
    }
}