//
//  SearchRepository.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 04/11/2020.
//

import RxSwift
import WallamarvelKit
import API

protocol SearchRepositoryType {
    func fetchHeroes(search: String, page: Range<Int>) -> Single<[Hero]>
}

final class SearchRepository: SearchRepositoryType {
    
    // MARK: Injected
    
    let api: API
    
    // MARK: Lifecycle
    
    init(api: API) {
        self.api = api
    }
    
    // MARK: SearchRepositoryType
    
    func fetchHeroes(search: String, page: Range<Int>) -> Single<[Hero]> {
        Single<[Hero]>.create { [unowned self] observer in
            self.api.searchHeroes(string: search, page: page) { result in
                observer(SingleEvent(result: result))
            }
            return Disposables.create()
        }
    }
}
