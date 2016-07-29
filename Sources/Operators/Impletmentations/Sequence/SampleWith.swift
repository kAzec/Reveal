//
//  SampleWith.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/4/9.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

final class SampleWith<T, Sampler: SourceType>: ValueCustomOperator<T, (value: T, samplerElement: Sampler.Element)> {
    typealias Sampled = (value: T, samplerElement: Sampler.Element)
    
    private let sampler: Sampler
    private let allowRepeats: Bool
    private let shouldSampleOn: (Sampler.Element -> Bool)?
    private let isSamplerTerminating: (Sampler.Element -> Bool)?
    
    private let latest = Atomic<T?>(nil)
    private var completed = false
    private var samplerTerminated = false
    
    private var samplerSubscription: Disposable? = nil

    init(_ sampler: Sampler, allowRepeats: Bool, shouldSampleOn: (Sampler.Element -> Bool)? = nil, isSamplerTerminating: (Sampler.Element -> Bool)? = nil) {
        self.sampler = sampler
        self.allowRepeats = allowRepeats
        self.shouldSampleOn = shouldSampleOn
        self.isSamplerTerminating = isSamplerTerminating
    }
    
    deinit {
        samplerSubscription?.dispose()
    }
    
    override func forward(sink: Sink) -> Source {
        observeSampler(next: sink, completed: nil)
        
        return { value in
            self.latest.swap(value)
        }
    }
    
    override func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void) {
        observeSampler(next: valueSink, completed: completionSink)
        
        return {
            self.latest.with { _ in
                self.completed = true
            }
            
            if self.samplerTerminated {
                completionSink()
            }
        }
    }
}

extension SampleWith {
    func observeSampler(next onNext: Sampled -> Void, completed onCompletion: (Void -> Void)?) {
        func fetchLatestValue() -> T? {
            return allowRepeats ? latest.value : latest.swap(nil)
        }
        
        samplerSubscription?.dispose()
        samplerSubscription = sampler.subscribe { [unowned self] element in
            if let latestValue = fetchLatestValue() where self.shouldSampleOn?(element) ?? true {
                let sampled = (latestValue, element)
                onNext(sampled)
            }
            
            if let onCompletion = onCompletion where self.isSamplerTerminating?(element) ?? false {
                self.latest.with { _ in
                    self.samplerTerminated = true
                }
                
                if self.completed {
                    onCompletion()
                }
            }
        }
    }
}