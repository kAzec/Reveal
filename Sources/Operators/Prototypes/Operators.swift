//
//  Operators.swift
//  Reveal
//
//  Created by 锋炜 刘 on 16/7/25.
//  Copyright © 2016年 kAzec. All rights reserved.
//

import Foundation

public class AnyOperator<I, O>: OperatorType {
    public typealias Source = I -> Void
    public typealias Sink = O -> Void
    
    public func forward(sink: Sink) -> Source {
        RevealUnimplemented()
    }
}

public class NodeOperator<I, O>: OperatorType {
    public typealias Source = I -> Void
    public typealias Sink = O -> Void
    
    public func forward(sink: Sink) -> Source {
        RevealUnimplemented()
    }
}

public class StreamOperator<IV, OV>: OperatorType {
    public typealias I = Signal<IV>
    public typealias O = Signal<OV>
    public typealias Source = I -> Void
    public typealias Sink = O -> Void
    public typealias ValueSink = OV -> Void
    
    public func forward(sink: Sink) -> Source {
        RevealUnimplemented()
    }
}

public class ResponseOperator<IV, E: ErrorType, OV, F: ErrorType>: OperatorType {
    public typealias I = Response<IV, E>
    public typealias O = Response<OV, F>
    public typealias Source = I -> Void
    public typealias Sink = O -> Void
    public typealias ValueSink = OV -> Void
    public typealias FailureSink = F -> Void
    
    public func forward(sink: Sink) -> Source {
        RevealUnimplemented()
    }
}

public class ValueOperator<I, O>: NodeOperator<I, O> {
    public func forwardSignal(sink: Signal<O>.Action) -> Signal<I>.Action {
        RevealUnimplemented()
    }
    
    public func forwardResponse<E>(sink: Response<O, E>.Action) -> Response<I, E>.Action {
        RevealUnimplemented()
    }
}

public class SignalOperator<IV, OV>: StreamOperator<IV, OV> {
    public func forwardResponse<E>(sink: Response<OV, E>.Action) -> Response<IV, E>.Action {
        RevealUnimplemented()
    }
}