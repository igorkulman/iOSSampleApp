//
//  RxBlocking.swift
//  TeamwireTests
//
//  Created by Igor Kulman on 12/02/2020.
//  Copyright © 2020 Teamwire GmbH. All rights reserved.
//

import Foundation


import RxSwift
import Foundation

extension ObservableConvertibleType {
    /// Converts an Observable into a `BlockingObservable` (an Observable with blocking operators).
    ///
    /// - parameter timeout: Maximal time interval BlockingObservable can block without throwing `RxError.timeout`.
    /// - returns: `BlockingObservable` version of `self`
    public func toBlocking(timeout: TimeInterval? = nil) -> BlockingObservable<Element> {
        return BlockingObservable(timeout: timeout, source: self.asObservable())
    }
}

/**
`BlockingObservable` is a variety of `Observable` that provides blocking operators.
It can be useful for testing and demo purposes, but is generally inappropriate for production applications.
If you think you need to use a `BlockingObservable` this is usually a sign that you should rethink your
design.
*/
public struct BlockingObservable<Element> {
    let timeout: TimeInterval?
    let source: Observable<Element>
}

extension BlockingObservable {
    /// Blocks current thread until sequence produces first element.
    ///
    /// If sequence terminates with error before producing first element, terminating error will be thrown.
    ///
    /// - returns: First element of sequence. If sequence is empty `nil` is returned.
    public func first() throws -> Element? {
        let results = self.materializeResult(max: 1)
        return try self.elementsOrThrow(results).first
    }
}


/// The `MaterializedSequenceResult` enum represents the materialized
/// output of a BlockingObservable.
///
/// If the sequence terminates successfully, the result is represented
/// by `.completed` with the array of elements.
///
/// If the sequence terminates with error, the result is represented
/// by `.failed` with both the array of elements and the terminating error.
public enum MaterializedSequenceResult<T> {
    case completed(elements: [T])
    case failed(elements: [T], error: Error)
}

extension BlockingObservable {
    fileprivate func materializeResult(max: Int? = nil, predicate: @escaping (Element) throws -> Bool = { _ in true }) -> MaterializedSequenceResult<Element> {
        var elements = [Element]()
        var error: Swift.Error?

        let lock = RunLoopLock(timeout: self.timeout)

        let d = SingleAssignmentDisposable()

        defer {
            d.dispose()
        }

        lock.dispatch {
            let subscription = self.source.subscribe { event in
                if d.isDisposed {
                    return
                }
                switch event {
                case .next(let element):
                    do {
                        if try predicate(element) {
                            elements.append(element)
                        }
                        if let max = max, elements.count >= max {
                            d.dispose()
                            lock.stop()
                        }
                    } catch let err {
                        error = err
                        d.dispose()
                        lock.stop()
                    }
                case .error(let err):
                    error = err
                    d.dispose()
                    lock.stop()
                case .completed:
                    d.dispose()
                    lock.stop()
                }
            }

            d.setDisposable(subscription)
        }

        do {
            try lock.run()
        } catch let err {
            error = err
        }

        if let error = error {
            return MaterializedSequenceResult.failed(elements: elements, error: error)
        }

        return MaterializedSequenceResult.completed(elements: elements)
    }

    fileprivate func elementsOrThrow(_ results: MaterializedSequenceResult<Element>) throws -> [Element] {
        switch results {
        case .failed(_, let error):
            throw error
        case .completed(let elements):
            return elements
        }
    }
}

#if os(Linux)
    import Foundation
    #if compiler(>=5.0)
    let runLoopMode: RunLoop.Mode = .default
    #else
    let runLoopMode: RunLoopMode = .defaultRunLoopMode
    #endif

    let runLoopModeRaw: CFString = unsafeBitCast(runLoopMode.rawValue._bridgeToObjectiveC(), to: CFString.self)
#else
    let runLoopMode: CFRunLoopMode = CFRunLoopMode.defaultMode
    let runLoopModeRaw = runLoopMode.rawValue
#endif

final class RunLoopLock {
    let _currentRunLoop: CFRunLoop

    let _calledRun = AtomicInt(0)
    let _calledStop = AtomicInt(0)
    var _timeout: TimeInterval?

    init(timeout: TimeInterval?) {
        self._timeout = timeout
        self._currentRunLoop = CFRunLoopGetCurrent()
    }

    func dispatch(_ action: @escaping () -> Void) {
        CFRunLoopPerformBlock(self._currentRunLoop, runLoopModeRaw) {
            if CurrentThreadScheduler.isScheduleRequired {
                _ = CurrentThreadScheduler.instance.schedule(()) { _ in
                    action()
                    return Disposables.create()
                }
            }
            else {
                action()
            }
        }
        CFRunLoopWakeUp(self._currentRunLoop)
    }

    func stop() {
        if decrement(self._calledStop) > 1 {
            return
        }
        CFRunLoopPerformBlock(self._currentRunLoop, runLoopModeRaw) {
            CFRunLoopStop(self._currentRunLoop)
        }
        CFRunLoopWakeUp(self._currentRunLoop)
    }

    func run() throws {
        if increment(self._calledRun) != 0 {
            fatalError("Run can be only called once")
        }
        if let timeout = self._timeout {
            #if os(Linux)
                switch Int(CFRunLoopRunInMode(runLoopModeRaw, timeout, false)) {
                case kCFRunLoopRunFinished:
                    return
                case kCFRunLoopRunHandledSource:
                    return
                case kCFRunLoopRunStopped:
                    return
                case kCFRunLoopRunTimedOut:
                    throw RxError.timeout
                default:
                    fatalError("This failed because `CFRunLoopRunResult` wasn't bridged to Swift.")
                }
            #else
                switch CFRunLoopRunInMode(runLoopMode, timeout, false) {
                case .finished:
                    return
                case .handledSource:
                    return
                case .stopped:
                    return
                case .timedOut:
                    throw RxError.timeout
                default:
                    return
                }
            #endif
        }
        else {
            CFRunLoopRun()
        }
    }
}

import class Foundation.NSLock

final class AtomicInt: NSLock {
    fileprivate var value: Int32
    public init(_ value: Int32 = 0) {
        self.value = value
    }
}

@discardableResult
@inline(__always)
func add(_ this: AtomicInt, _ value: Int32) -> Int32 {
    this.lock()
    let oldValue = this.value
    this.value += value
    this.unlock()
    return oldValue
}

@discardableResult
@inline(__always)
func sub(_ this: AtomicInt, _ value: Int32) -> Int32 {
    this.lock()
    let oldValue = this.value
    this.value -= value
    this.unlock()
    return oldValue
}

@discardableResult
@inline(__always)
func fetchOr(_ this: AtomicInt, _ mask: Int32) -> Int32 {
    this.lock()
    let oldValue = this.value
    this.value |= mask
    this.unlock()
    return oldValue
}

@inline(__always)
func load(_ this: AtomicInt) -> Int32 {
    this.lock()
    let oldValue = this.value
    this.unlock()
    return oldValue
}

@discardableResult
@inline(__always)
func increment(_ this: AtomicInt) -> Int32 {
    return add(this, 1)
}

@discardableResult
@inline(__always)
func decrement(_ this: AtomicInt) -> Int32 {
    return sub(this, 1)
}

@inline(__always)
func isFlagSet(_ this: AtomicInt, _ mask: Int32) -> Bool {
    return (load(this) & mask) != 0
}
