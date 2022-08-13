//
//  MainViewModel.swift
//  RxSwiftTest
//
//  Created by Ekaterina Nedelko on 13.08.22.
//

import Foundation
import RxSwift
import RxRelay

class MainViewModel {
    
    private var disposeBag = DisposeBag()
    
    private var mainModel = MainModel()
    
    private let attemptsPublishSubject = PublishSubject<Int>()
    lazy var attemptsPublishSubjectObservable = attemptsPublishSubject.asObservable()
    
    private let attemptsReplaySubject = ReplaySubject<Int>.create(bufferSize: 2)
    lazy var attemptsReplaySubjectObservable = attemptsReplaySubject.asObservable()
    
    private let attemptsBehaviorSubject = BehaviorSubject<Int>(value: 0)
    lazy var attemptsBehaviorSubjectObservable = attemptsBehaviorSubject.asObservable()
    
    private let attemptsBehaviorRelay = BehaviorRelay<Int>(value: 0)
    lazy var attemptsBehaviorRelayObservable = attemptsBehaviorRelay.asObservable()
    
    func updateAttemptsNumber() {
        mainModel.getAttemptsNumber()
            .subscribe { attemptsNumber in
                self.attemptsPublishSubject.onNext(attemptsNumber)
                self.attemptsReplaySubject.onNext(attemptsNumber)
                self.attemptsBehaviorSubject.onNext(attemptsNumber)
                self.attemptsBehaviorRelay.accept(attemptsNumber)
            } onError: { error in
                print("error")
            }
            .disposed(by: disposeBag)
    }
}

