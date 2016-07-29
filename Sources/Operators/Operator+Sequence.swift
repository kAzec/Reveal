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

public func flatten<S: SequenceType>() -> ValueOperator<S, S.Generator.Element> {
    return Flatten()
}

public func flatMap<I, S: SequenceType>(transform: I -> S) -> ValueOperator<I, S.Generator.Element> {
    return Map(transform) + Flatten()
}

public func ignoreNil<T>() -> ValueOperator<T?, T> {
    return IgnoreNil()
}

public func index<T>() -> ValueOperator<T, (index: Int, value: T)> {
    return Index()
}

public func map<I, O>(transform: I -> O) -> ValueOperator<I, O> {
    return Map(transform)
}

public func sample<T, Source: SourceType>(with source: Source, allowRepeats: Bool = false) -> ValueOperator<T, (value: T, samplerElement: Source.Element)> {
    return SampleWith(source, allowRepeats: allowRepeats, shouldSampleOn: nil, isSamplerTerminating: nil)
}

public func sample<T, V, Source: SourceType where Source.Element == Signal<V>>(with source: Source, allowRepeats: Bool = false) -> ValueOperator<T, (value: T, samplerElement: Signal<V>)> {
    return SampleWith(source, allowRepeats: allowRepeats, shouldSampleOn: nil, isSamplerTerminating: { $0.completing })
}

public func sample<T, V, E, Source: SourceType where Source.Element == Response<V, E>>(with source: Source, allowRepeats: Bool = false) -> ValueOperator<T, (value: T, samplerElement: Response<V, E>)> {
    return SampleWith(source, allowRepeats: allowRepeats, shouldSampleOn: { !$0.failing }, isSamplerTerminating: { $0.terminating })
}

public func sample<T, Source: SourceType>(on source: Source, allowRepeats: Bool = false) -> ValueOperator<T, T> {
    return sample(with: source) + Map{ $0.value }
}

public func sample<T, V, Source: SourceType where Source.Element == Signal<V>>(on source: Source, allowRepeats: Bool = false) -> ValueOperator<T, T> {
    return sample(with: source) + Map{ $0.value }
}

public func sample<T, V, E: ErrorType, Source: SourceType where Source.Element == Response<V, E>>(on source: Source, allowRepeats: Bool = false) -> ValueOperator<T, T> {
    return sample(with: source) + Map{ $0.value }
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

public func skip<T, Source: SourceType>(until source: Source) -> ValueOperator<T, T> {
    return SkipUntil(source, predicate: nil)
}

public func skip<T, V, E: ErrorType, Source: SourceType where Source.Element == Response<V, E>>(until source: Source) -> ValueOperator<T, T> {
    return SkipUntil(source, predicate: { $0.failing })
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

public func take<T, Source: SourceType>(until source: Source) -> ValueOperator<T, T> {
    return TakeUntil(source, predicate: nil)
}

public func take<T, V, E: ErrorType, Source: SourceType where Source.Element == Response<V, E>>(until source: Source) -> ValueOperator<T, T> {
    return TakeUntil(source, predicate: { $0.failing })
}

public func take<T>(while predicate: T -> Bool) -> ValueOperator<T, T> {
    return TakeWhile(predicate)
}

public func takeLast<T>(count: Int) -> SignalOperator<T, [T]> {
    return TakeLast(count)
}

public func takeLast<T>() -> SignalOperator<T, T> {
    return TakeLastOne()
}

public func times<T>(multiplier: Int) -> ValueOperator<T, T> {
    return Times(multiplier)
}