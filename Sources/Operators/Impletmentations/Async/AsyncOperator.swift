//
//  AsyncOperator.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/17.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

class AsyncOperator<I, O, Scheduler: SchedulerType>: ValueOperator<I, O> {
    let lock = NSLock()
    let scheduler: Scheduler
    let scheduledDisposables = CompositeDisposable()
    
    init(scheduler: Scheduler) {
        self.scheduler = scheduler
        lock.name = String(self.dynamicType)
    }
    
    deinit {
        scheduledDisposables.dispose()
    }
    
    func forwardCompletion(completion completionSink: Void -> Void, next nextSink: O -> Void) -> (Void -> Void)? {
        return nil
    }
    
    final override func forwardSignal(sink: Signal<O>.Action) -> Signal<I> -> Void {
        let completionSink = { [weak self] in
            sink(.completed)
            self?.scheduledDisposables.dispose()
        }
        let nextSink = { sink(.next($0)) }
        
        let onNext = forward(nextSink)
        
        let onCompletion: Void -> Void
        
        if let forwardCompletion = self.forwardCompletion(completion: completionSink, next: nextSink) {
            onCompletion = forwardCompletion
        } else {
            onCompletion = { self.schedule(completionSink) }
        }
        
        
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
        let completionSink = { [weak self] in
            sink(.completed)
            self?.scheduledDisposables.dispose()
        }
        let nextSink = { sink(.next($0)) }
        
        let onNext = forward(nextSink)
        
        let onCompletion: Void -> Void
        
        if let forwardCompletion = self.forwardCompletion(completion: completionSink, next: nextSink) {
            onCompletion = forwardCompletion
        } else {
            onCompletion = { self.schedule(completionSink) }
        }
        
        return { response in
            switch response {
            case .next(let value):
                onNext(value)
            case .failed(let error):
                self.schedule {
                    sink(.failed(error))
                    self.scheduledDisposables.dispose()
                }
            case .completed:
                onCompletion()
            }
        }
    }
}

extension AsyncOperator {
    func schedule(action: Void -> Void) -> Disposable? {
        let disposable = scheduler.schedule { [weak self] in
            guard let weakSelf = self else { return }
            
            weakSelf.lock.lock()
            defer { weakSelf.lock.unlock() }
            
            action()
        }
        
        scheduledDisposables += disposable
        return disposable
    }
}

extension AsyncOperator where Scheduler: DelaySchedulerType {
    func schedule(after delay: NSTimeInterval, action: Void -> Void) -> Disposable? {
        let disposable = scheduler.schedule(after: delay) { [weak self] in
            guard let weakSelf = self else { return }
            
            weakSelf.lock.lock()
            defer { weakSelf.lock.unlock() }
            
            action()
        }
        
        scheduledDisposables += disposable
        return disposable
    }
}