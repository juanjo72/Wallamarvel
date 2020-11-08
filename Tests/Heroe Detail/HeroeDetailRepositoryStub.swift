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
    
    lazy var heroe: Hero = {
        let url = Bundle(for: Self.self).url(forResource: "hero", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode(Hero.self, from: data)
    }()
    
    init(scenario: Scenario) {
        self.scenario = scenario
    }
    
    func fetchDetail() -> Single<Hero> {
        switch scenario {
        case .sunnyDay:
            return Single<Hero>.just(heroe).delay(.milliseconds(200), scheduler: MainScheduler.instance)
        case .error:
            return Single<Hero>.error(APIError.noConnection).delay(.milliseconds(200), scheduler: MainScheduler.instance)
        }
    }
}
