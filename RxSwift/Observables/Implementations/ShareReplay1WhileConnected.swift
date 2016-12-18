//
//  ShareReplay1WhileConnected.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation

// optimized version of share replay for most common case
final class ShareReplay1WhileConnected<Element>
    : Observable<Element>
    , ObserverType
    , SynchronizedUnsubscribeType {

    typealias DisposeKey = Bag<(Event<Element>) -> ()>.KeyType

    private let _source: Observable<Element>

    private var _lock = createLock()

    private var _connection: SingleAssignmentDisposable?
    private var _element: Element?
    private var _observers = Bag<(Event<Element>) -> ()>()

    init(source: Observable<Element>) {
        self._source = source
    }

    override func subscribe<O : ObserverType>(_ observer: O) -> Disposable where O.E == E {
        lock(_lock)
        let value = _synchronized_subscribe(observer)
        unlock(_lock)
        return value
    }

    @inline(__always)
    private func _synchronized_subscribe<O : ObserverType>(_ observer: O) -> Disposable where O.E == E {
        if let element = self._element {
            observer.on(.next(element))
        }

        let initialCount = self._observers.count

        let disposeKey = self._observers.insert(observer.on)

        if initialCount == 0 {
            let connection = SingleAssignmentDisposable()
            _connection = connection

            connection.setDisposable(self._source.subscribe(self))
        }

        return SubscriptionDisposable(owner: self, key: disposeKey)
    }

    func synchronizedUnsubscribe(_ disposeKey: DisposeKey) {
        lock(_lock)
        _synchronized_unsubscribe(disposeKey)
        unlock(_lock)
    }

    @inline(__always)
    private func _synchronized_unsubscribe(_ disposeKey: DisposeKey) {
        // if already unsubscribed, just return
        if self._observers.removeKey(disposeKey) == nil {
            return
        }

        if _observers.count == 0 {
            _connection?.dispose()
            _connection = nil
            _element = nil
        }
    }

    func on(_ event: Event<E>) {
        lock(_lock)

        switch event {
        case .next(let element):
            _element = element
            dispatch(_observers, event)
        case .error, .completed:
            _element = nil
            _connection?.dispose()
            _connection = nil
            let observers = _observers
            _observers = Bag()
            dispatch(observers, event)
        }
        
        unlock(_lock)
    }

    deinit {
        releaseLock(_lock)
    }
}
