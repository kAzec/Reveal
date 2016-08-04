//
//  IntermediateType+Flatten.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/8/4.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

// MARK: - Merge
public func merge<V, S: StreamProxyType where S.Value: SourceType, S.Value.Element == Signal<V>>(stream: S) -> Stream<V> {
    return Stream("Merge") { observer in
        let disposables = CompositeDisposable()
        var sessions: Int32 = 1
        
        disposables += stream.subscribe { signal in
            if case .next(let source) = signal {
                OSAtomicIncrement32(&sessions)
                disposables += source.subscribe { signal in
                    if case .next(let value) = signal {
                        observer(.next(value))
                    } else {
                        if OSAtomicDecrement32(&sessions) == 0 {
                            observer(.completed)
                        } else {
                            disposables.prune()
                        }
                    }
                }
            } else {
                if OSAtomicDecrement32(&sessions) == 0 {
                    observer(.completed)
                }
            }
        }
        
        return disposables
    }
}

public func merge<V, E, S: StreamProxyType where S.Value: SourceType, S.Value.Element == Response<V, E>>(stream: S) -> Operation<V, E> {
    return Operation("Merge") { observer in
        let disposables = CompositeDisposable()
        var sessions: Int32 = 1
        
        disposables += stream.subscribe { signal in
            if case .next(let source) = signal {
                OSAtomicIncrement32(&sessions)
                disposables += source.subscribe { response in
                    switch response {
                    case .next, .failed:
                        observer(response)
                    case .completed:
                        if OSAtomicDecrement32(&sessions) == 0 {
                            observer(.completed)
                        } else {
                            disposables.prune()
                        }
                    }
                }
            } else {
                if OSAtomicDecrement32(&sessions) == 0 {
                    observer(.completed)
                }
            }
        }
        
        return disposables
    }
}

public func merge<V, O: OperationProxyType where O.Value: SourceType, O.Value.Element == Signal<V>>(operation: O) -> Operation<V, O.Error> {
    return Operation("Merge") { observer in
        let disposables = CompositeDisposable()
        var sessions: Int32 = 1
        
         disposables += operation.subscribe { response in
            switch response {
            case .next(let source):
                OSAtomicIncrement32(&sessions)
                disposables += source.subscribe { signal in
                    if case .next(let value) = signal {
                        observer(.next(value))
                    } else {
                        if OSAtomicDecrement32(&sessions) == 0 {
                            observer(.completed)
                        } else {
                            disposables.prune()
                        }
                    }
                }
            case .failed(let error):
                observer(.failed(error))
            case .completed:
                if OSAtomicDecrement32(&sessions) == 0 {
                    observer(.completed)
                }
            }
        }
        
        return disposables
    }
}

public func merge<V, O: OperationProxyType where O.Value: SourceType, O.Value.Element == Response<V, O.Error>>(operation: O) -> Operation<V, O.Error> {
    return Operation("Merge") { observer in
        let disposables = CompositeDisposable()
        var sessions: Int32 = 1
        
        disposables += operation.subscribe { response in
            switch response {
            case .next(let source):
                OSAtomicIncrement32(&sessions)
                disposables += source.subscribe { response in
                    switch response {
                    case .next, .failed:
                        observer(response)
                    case .completed:
                        if OSAtomicDecrement32(&sessions) == 0 {
                            observer(.completed)
                        } else {
                            disposables.prune()
                        }
                    }
                }
            case .failed(let error):
                observer(.failed(error))
            case .completed:
                if OSAtomicDecrement32(&sessions) == 0 {
                    observer(.completed)
                }
            }
        }
        
        return disposables
    }
}

public func switchToLatest<V, S: StreamProxyType where S.Value: SourceType, S.Value.Element == Signal<V>>(stream: S) -> Stream<V> {
    return Stream("SwitchToLatest") { observer in
        let disposable = SerialDisposable()
        var sessions: Int32 = 1
        
        return disposable + stream.subscribe { signal in
            if case .next(let source) = signal {
                OSAtomicIncrement32(&sessions)
                disposable.innerDisposable = source.subscribe { signal in
                    if case .next(let value) = signal {
                        observer(.next(value))
                    } else {
                        if OSAtomicDecrement32(&sessions) == 0 {
                            observer(.completed)
                        } else {
                            disposable.innerDisposable = nil
                        }
                    }
                }
            } else {
                if OSAtomicDecrement32(&sessions) == 0 {
                    observer(.completed)
                }
            }
        }
    }
}

public func switchToLatest<V, O: OperationProxyType where O.Value: SourceType, O.Value.Element == Signal<V>>(operation: O) -> Operation<V, O.Error> {
    return Operation("SwitchToLatest") { observer in
        let disposable = SerialDisposable()
        var sessions: Int32 = 1
        
        return disposable + operation.subscribe { response in
            switch response {
            case .next(let source):
                OSAtomicIncrement32(&sessions)
                disposable.innerDisposable = source.subscribe { signal in
                    if case .next(let value) = signal {
                        observer(.next(value))
                    } else {
                        if OSAtomicDecrement32(&sessions) == 0 {
                            observer(.completed)
                        } else {
                            disposable.innerDisposable = nil
                        }
                    }
                }
            case .failed(let error):
                observer(.failed(error))
            case .completed:
                if OSAtomicDecrement32(&sessions) == 0 {
                    observer(.completed)
                }
            }
        }
    }
}

public func switchToLatest<V, O: OperationProxyType where O.Value: SourceType, O.Value.Element == Response<V, O.Error>>(operation: O) -> Operation<V, O.Error> {
    return Operation("SwitchToLatest") { observer in
        let disposable = SerialDisposable()
        var sessions: Int32 = 1
        
        return disposable + operation.subscribe { response in
            switch response {
            case .next(let source):
                OSAtomicIncrement32(&sessions)
                disposable.innerDisposable = source.subscribe { response in
                    switch response {
                    case .next, .failed:
                        observer(response)
                    case .completed:
                        if OSAtomicDecrement32(&sessions) == 0 {
                            observer(.completed)
                        } else {
                            disposable.innerDisposable = nil
                        }
                    }
                }
            case .failed(let error):
                observer(.failed(error))
            case .completed:
                if OSAtomicDecrement32(&sessions) == 0 {
                    observer(.completed)
                }
            }
        }
    }
}