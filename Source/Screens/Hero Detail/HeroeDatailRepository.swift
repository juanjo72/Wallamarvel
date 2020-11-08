//
//  HeroeDatailRepository.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 04/11/2020.
//

import WallamarvelKit
import RxSwift
import RxCocoa
import API

protocol HeroeDetailRespositoryType {
    func fetchDetail() -> Single<Hero>
}

final class HeroeDetailRespository: HeroeDetailRespositoryType {
    
    // MARK: Injected
    
    let heroeId: Int
    let api: API
    
    // MARK: Lifecycle
    
    init(heroeId: Int, api: API) {
        self.heroeId = heroeId
        self.api = api
    }
    
    // MARK: HeroeDetailRespositoryType
    
    func fetchDetail() -> Single<Hero> {
        Single<Hero>.create { [unowned self] observer in
            self.api.fetchHeroeDetail(id: self.heroeId) { result in
                observer(SingleEvent(result: result))
            }
            return Disposables.create()
        }
    }
}
