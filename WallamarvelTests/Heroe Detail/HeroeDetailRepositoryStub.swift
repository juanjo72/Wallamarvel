//
//  HeroeDetailRepositoryStub.swift
//  WallamarvelTests
//
//  Created by Juanjo García Villaescusa on 06/11/2020.
//

@testable import Wallamarvel
import WallamarvelKit
import RxSwift
import RxCocoa
import API

final class HeroeDetailRepositoryStub: HeroeDetailRespositoryType {
    enum Scenario {
        case sunnyDay
        case error
    }
    
    let scenario: Scenario
    
    lazy var heroe: Heroe = {
        let url = Bundle(for: Self.self).url(forResource: "heroe", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode(Heroe.self, from: data)
    }()
    
    init(scenario: Scenario) {
        self.scenario = scenario
    }
    
    func fetchDetail() -> Single<Heroe> {
        switch scenario {
        case .sunnyDay:
            return Single<Heroe>.just(heroe).delay(.milliseconds(200), scheduler: MainScheduler.instance)
        case .error:
            return Single<Heroe>.error(APIError.noConnection).delay(.milliseconds(200), scheduler: MainScheduler.instance)
        }
    }
}
