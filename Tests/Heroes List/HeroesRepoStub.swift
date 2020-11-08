//
//  HeroesRepoStub.swift
//  WallamarvelTests
//
//  Created by Juanjo García Villaescusa on 06/11/2020.
//

@testable import Wallamarvel
import WallamarvelKit
import RxSwift
import RxCocoa
import API

final class HeroesRepoStub: HeroesRepositoryType {
    enum Scenario {
        case sunnyDay
        case error
    }
    
    let scenario: Scenario
    
    lazy var heroes: [Hero] = {
        let url = Bundle(for: Self.self).url(forResource: "heroes", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode([Hero].self, from: data)
    }()
    
    init(scenario: Scenario) {
        self.scenario = scenario
    }

    func fetchHeroes(page: Range<Int>) -> Single<[Hero]> {
        switch scenario {
        case .sunnyDay:
            let heroesPage = Array(heroes[page])
            return Single<[Hero]>.just(heroesPage).delay(.milliseconds(500), scheduler: MainScheduler.instance)
        case .error:
            return Single<[Hero]>.error(APIError.noConnection).delay(.milliseconds(200), scheduler: MainScheduler.instance)
        }
    }
}
