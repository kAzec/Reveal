//
//  AsyncOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/29.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class AsyncOperator<I, O, Scheduler: SchedulerType>: ValueOperator<I, O>, AsyncType {
    final let scheduler: Scheduler
    final let lock = NSLock()
    
    init(scheduler: Scheduler) {
        self.scheduler = scheduler
        lock.name = String(self.dynamicType)
    }
    
    func forwardCompletion(completion completionSink: Void -> Void, next valueSink: Sink) -> (Void -> Void)? {
        return nil
    }
    
    private func makeOnCompletion(completion completionSink: Void -> Void, next nextSink: Sink) -> (Void -> Void) {
        if let customOnCompletion = self.forwardCompletion(completion: completionSink, next: nextSink) {
            return customOnCompletion
        } else {
            return {
                self.schedule { _ in
                    completionSink()
                }
            }
        }
    }
    
    final override func forwardSignal(sink: Signal<O>.Action) -> Signal<I> -> Void {
        let completionSink = { sink(.completed) }
        let nextSink = { sink(.next($0)) }
        
        let onNext = forward(nextSink)
        let onCompletion = makeOnCompletion(completion: completionSink, next: nextSink)
        
        return { signal in
            switch signal {
            case .next(let value):
                onNext(value)
            case .completed:
                onCompletion()
            }
        }
    }
    
    final override func forwardResponse<E>(sink: Response<O, E>.Action) -> Response<I, E> -> Void {
        let completionSink = { sink(.completed) }
        let nextSink = { sink(.next($0)) }
        
        let onNext = forward(nextSink)
        let onCompletion = makeOnCompletion(completion: completionSink, next: nextSink)
        
        return { response in
            switch response {
            case .next(let value):
                onNext(value)
            case .failed(let error):
                self.schedule { _ in
                    sink(.failed(error))
                }
            case .completed:
                onCompletion()
            }
        }
    }
}

protocol AsyncType: class {
    associatedtype Scheduler: SchedulerType
    
    var scheduler: Scheduler { get }
    var lock: NSLock { get }
}

extension AsyncType {
    private func lockedWithSelf(action: Self -> Void) -> (Void -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            
            weakSelf.lock.lock()
            defer { weakSelf.lock.unlock() }
            action(weakSelf)
        }
    }
    
    func schedule(action: Self -> Void) -> Disposable? {
        return scheduler.schedule(lockedWithSelf(action))
    }
}

extension AsyncType where Scheduler: DelaySchedulerType {
    func schedule(after delay: NSTimeInterval, action: Self -> Void) -> Disposable? {
        return scheduler.schedule(after: delay, action: lockedWithSelf(action))
    }
}