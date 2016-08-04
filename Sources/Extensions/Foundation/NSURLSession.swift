//
//  NSURLSession.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/1.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public extension NSURLSession {
    private static let defaultError = NSError(domain: "Reveal.rDataWithRequest", code: 1, userInfo: nil)
    
    func rDataWithRequest(request: NSURLRequest) -> OperationProducer<(NSData, NSURLResponse), NSError> {
        return OperationProducer { observer, disposable in
            let task = self.dataTaskWithRequest(request) { data, response, error in
                if let data = data, response = response {
                    observer(.next(data, response))
                    observer(.completed)
                } else {
                    observer(.failed(error ?? NSURLSession.defaultError))
                }
            }
            
            disposable += {
                task.cancel()
            }
            
            task.resume()
        }
    }
}