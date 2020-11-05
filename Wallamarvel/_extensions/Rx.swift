//
//  Rx.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 05/11/2020.
//

import RxSwift
import RxCocoa

extension RxSwift.ObservableType {
    func unwrap<Result>() -> Observable<Result> where Element == Result? {
         compactMap { $0 }
    }
}
