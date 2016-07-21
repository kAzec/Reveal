//
//  SampleOn.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/9.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation
import Atomic

final class SampleOn<T, Sampler: SourceType>: ValueCustomOperator<T, T> {
    private let sampler: Sampler
    private let allowRepeats: Bool
    private let shouldSampleOn: (Sampler.Element -> Bool)?
    private let isSamplerCompleting: (Sampler.Element -> Bool)?
    
    private let latest = Atomic<T?>(nil)
    private var completed = false
    private var samplerCompleted = false
    
    private var samplerSubscription: Subscription<Sampler>? = nil

    init(_ sampler: Sampler, allowRepeats: Bool, shouldSampleOn: (Sampler.Element -> Bool)? = nil, isSamplerCompleting: (Sampler.Element -> Bool)? = nil) {
        self.sampler = sampler
        self.allowRepeats = allowRepeats
        self.shouldSampleOn = shouldSampleOn
        self.isSamplerCompleting = isSamplerCompleting
    }
    
    deinit {
        samplerSubscription?.dispose()
    }
    
    override func forward(sink: T -> Void) -> (T -> Void) {
        observeSampler(next: sink, completion: nil)
        
        return { value in
            self.latest.swap(value)
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next nextSink: T -> Void) -> (Void -> Void) {
        observeSampler(next: nextSink, completion: completionSink)
        
        return {
            self.latest.with { _ in
                self.completed = true
            }
            
            if self.samplerCompleted {
                completionSink()
            }
        }
    }
}

extension SampleOn {
    func observeSampler(next onNext: T -> Void, completion onCompletion: (Void -> Void)?) {
        func fetchLatestValue() -> T? {
            return allowRepeats ? latest.value : latest.swap(nil)
        }
        
        samplerSubscription?.dispose()
        samplerSubscription = sampler.subscribe { [unowned self] value in
            if let latest = fetchLatestValue() where self.shouldSampleOn?(value) ?? true {
                onNext(latest)
            }
            
            if let onCompletion = onCompletion where self.isSamplerCompleting?(value) ?? false {
                self.latest.with { _ in
                    self.samplerCompleted = true
                }
                
                if self.completed {
                    onCompletion()
                }
            }
        }
    }
}