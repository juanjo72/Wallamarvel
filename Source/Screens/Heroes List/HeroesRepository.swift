//
//  LandingControllerRepository.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import API
import WallamarvelKit
import RxSwift
import RxCocoa

protocol HeroesRepositoryType {
    func fetchHeroes(page: Range<Int>) -> Single<[Hero]>
}

final class HeroesRepository: HeroesRepositoryType {
    
    // MARK: Injected
    
    let api: API
    
    // MARK: Lifecycle
    
    init(api: API) {
        self.api = api
    }
    
    // MARK: HeroesRepositoryType
    
    func fetchHeroes(page: Range<Int>) -> Single<[Hero]> {
        Single<[Hero]>.create { [unowned self] observer in
            self.api.fetchHeroes(page: page) { result in
                observer(SingleEvent(result: result))
            }
            return Disposables.create()
        }
    }
}

extension SingleEvent {
    init(result: Result<Element, APIError>) {
        switch result {
        case .success(let value):
            self = .success(value)
        case .failure(let error):
            self = .error(error)
        }
    }
}
