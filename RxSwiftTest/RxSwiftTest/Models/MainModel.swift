//
//  MainModel.swift
//  RxSwiftTest
//
//  Created by Ekaterina Nedelko on 13.08.22.
//

import Foundation
import RxSwift

class MainModel {
    
    private let availableAttemptsNumber = [4, 6, 8]
    
    func getAttemptsNumber() -> Observable<Int>  {
        Observable.just(availableAttemptsNumber.randomElement() ?? 0)
    }
}
