//
//  main.swift
//  Tests
//
//  Created by Krunoslav Zaher on 9/26/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import RxSwift
#if !SWIFT_PACKAGE
import RxCocoa
#endif
import AppKit
import CoreLocation

let bechmarkTime = true

func allocation() {
    
}

repeat {
compareTwoImplementations(benchmarkTime: true, benchmarkMemory: false, first: {
    let publishSubject = PublishSubject<Int>()

    //let a = Observable.just(1)

    var i = 0
    //combineLatest(a,
        _ = publishSubject.asDriver(onErrorJustReturn: 0) //.asDriver(onErrorJustReturn: -1)
    /*create { (o: AnyObserver<Int>) in
            for i in 0..<100 {
                o.on(.next(i))
            }
            return Disposables.create()
        }*/
        //.retryWhen { $0 }
            .map { $0 }
            .map { $0 }
            .map { $0 }
            .map { $0 }
            .map { $0 }
            .map { $0 }
            .map { $0 }
            .map { $0 }
            /*.map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }
            .map { $0 }.filter { _ in true }*/
        //.map { $0 }
        /*.map { $0 }
        .map { $0 }
        .map { $0 }
        .map { $0 }*/
        /*.filter { _ in true }//){ x, _ in x }
        .map { $0 }
        .flatMap { Observable.just($0) }*/
        .drive(onNext: { x in
        //.subscribe(onNext: { (x: Int) in
            i += x
        })


    for i in 0..<100 {
        publishSubject.on(.next(i))
    }

}, second: {
    
})
} while true
