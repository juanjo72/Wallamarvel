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

protocol LandingControllerRepositoryType {
    func fetchHeroes(search: String?, page: Range<Int>) -> Single<[Heroe]>
}

final class LandingControllerRepository: LandingControllerRepositoryType {
    
    // MARK: Injected
    
    let api: API
    
    // MARK: Lifecycle
    
    init(api: API) {
        self.api = api
    }
    
    // MARK: LandingControllerRepositoryType
    
    func fetchHeroes(search: String?, page: Range<Int>) -> Single<[Heroe]> {
        Single<[Heroe]>.create { [unowned self] observer in
            if let search = search {
                self.api.searchHeroes(string: search, page: page) { result in
                    observer(SingleEvent(result: result))
                }
            } else {
                self.api.fetchHeroes(page: page) { result in
                    observer(SingleEvent(result: result))
                }
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
