//
//  Operator+Sequence.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/23.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public func combinePreivous<T>(initial: T? = nil) -> ValueOperator<T, (previous: T, value: T)> {
    return CombinePrevious(initial)
}

public func distinct<T: Hashable>() -> ValueOperator<T, T> {
    return Distinct()
}

public func distinctLastest<T>(predicate: (T, T) -> Bool) -> ValueOperator<T, T> {
    return DistinctLatest(predicate)
}

public func distinctLastest<T: Comparable>() -> ValueOperator<T, T> {
    return DistinctLatest(==)
}

public func filter<T>(includeValue: T -> Bool) -> ValueOperator<T, T> {
    return Filter(includeValue)
}

public func ignoreNil<T>() -> ValueOperator<T?, T> {
    return IgnoreNil()
}

public func index<T>() -> ValueOperator<T, (index: Int, value: T)> {
    return Index()
}

public func map<I, O>(transform: I -> O) -> ValueOperator<I, O> {
    return Map(transform: transform)
}

public func flatMap<I, O>(transform: I -> O?) -> ValueOperator<I, O> {
    return Map(transform: transform) + IgnoreNil()
}

public func sample<T, U>(with node: Node<U>, allowRepeats: Bool = false) -> ValueOperator<T, (value: T, samplerElement: U)> {
    return SampleWith(node, allowRepeats: allowRepeats, shouldSampleOn: nil, isSamplerTerminating: nil)
}

public func sample<T, U>(with stream: Stream<U>, allowRepeats: Bool = false) -> ValueOperator<T, (value: T, samplerElement: Signal<U>)> {
    return SampleWith(stream, allowRepeats: allowRepeats, shouldSampleOn: nil, isSamplerTerminating: { $0.completing })
}

public func sample<T, U, E>(with stream: Operation<U, E>, allowRepeats: Bool = false) -> ValueOperator<T, (value: T, samplerElement: Response<U, E>)> {
    return SampleWith(stream, allowRepeats: allowRepeats, shouldSampleOn: { !$0.failing }, isSamplerTerminating: { $0.terminating })
}

public func sample<T, U>(on node: Node<U>, allowRepeats: Bool = false) -> ValueOperator<T, T> {
    return SampleWith(node, allowRepeats: allowRepeats, shouldSampleOn: nil, isSamplerTerminating: nil) + Map(transform: { $0.value })
}

public func sample<T, U>(on stream: Stream<U>, allowRepeats: Bool = false) -> ValueOperator<T, T> {
    return SampleWith(stream, allowRepeats: allowRepeats, shouldSampleOn: nil, isSamplerTerminating: { $0.completing }) + Map(transform: { $0.value })
}

public func sample<T, U, E>(on stream: Operation<U, E>, allowRepeats: Bool = false) -> ValueOperator<T, T> {
    return SampleWith(stream, allowRepeats: allowRepeats, shouldSampleOn: { !$0.failing }, isSamplerTerminating: { $0.terminating }) + Map(transform: { $0.value })
}

public func scan<I, O>(initial: O, combine: (O, I) -> O) -> ValueOperator<I, O> {
    return Scan(initial, combine: combine)
}

public func skip<T>(count: Int) -> ValueOperator<T, T> {
    return SkipCount(count)
}

public func skip<T, Scheduler: DelaySchedulerType>(for milliseconds: NSTimeInterval, on scheduler: Scheduler) -> ValueOperator<T, T> {
    return SkipTime(milliseconds, scheduler: scheduler)
}

public func skip<T, U>(until node: Node<U>) -> ValueOperator<T, T> {
    return SkipUntil(node, predicate: nil)
}

public func skip<T, U>(until stream: Stream<U>) -> ValueOperator<T, T> {
    return SkipUntil(stream, predicate: { $0.completing })
}

public func skip<T, U, E>(until operation: Operation<U, E>) -> ValueOperator<T, T> {
    return SkipUntil(operation, predicate: { $0.terminating})
}

public func skip<T>(while predicate: T -> Bool) -> ValueOperator<T, T> {
    return SkipWhile(predicate)
}

public func take<T>(count: Int) -> ValueOperator<T, T> {
    return TakeCount(count)
}

public func take<T, Scheduler: DelaySchedulerType>(for milliseconds: NSTimeInterval, on scheduler: Scheduler) -> ValueOperator<T, T> {
    return TakeTime(milliseconds, scheduler: scheduler)
}

public func take<T, U>(until node: Node<U>) -> ValueOperator<T, T> {
    return TakeUntil(node, predicate: nil)
}

public func take<T, U>(until stream: Stream<U>) -> ValueOperator<T, T> {
    return TakeUntil(stream, predicate: { $0.completing })
}

public func take<T, U, E>(until operation: Operation<U, E>) -> ValueOperator<T, T> {
    return TakeUntil(operation, predicate: { $0.terminating})
}

public func take<T>(while predicate: T -> Bool) -> ValueOperator<T, T> {
    return TakeWhile(predicate)
}

public func takeLast<T>(count: Int) -> SignalOperator<T, T> {
    return TakeLast(count)
}

public func takeLast<T>() -> SignalOperator<T, T> {
    return TakeLastOne()
}

public func times<T>(multiplier: Int) -> ValueOperator<T, T> {
    return Times(multiplier)
}