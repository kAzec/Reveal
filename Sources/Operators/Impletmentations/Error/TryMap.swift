//
//  TryMap.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/18.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class TryMap<I, O, E: ErrorType>: ResponseOperator<I, E, O, E> {
    private let transform: I -> Result<O, E>
    
    init(_ transform: I -> Result<O, E>) {
        self.transform = transform
    }
    
    override func forward(sink: Response<O, E>.Action) -> Response<I, E>.Action {
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