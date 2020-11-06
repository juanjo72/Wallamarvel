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
    
    lazy var heroes: [Heroe] = {
        let url = Bundle(for: Self.self).url(forResource: "heroes", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode([Heroe].self, from: data)
    }()
    
    private var callsCount = 0
    
    init(scenario: Scenario) {
        self.scenario = scenario
    }
    
    func fetchHeroes(page: Range<Int>) -> Single<[Heroe]> {
        switch scenario {
        case .sunnyDay:
            let heroesPage = Array(heroes[page])
            return Single<[Heroe]>.just(heroesPage).delay(.milliseconds(200), scheduler: MainScheduler.instance)
        case .error:
            return Single<[Heroe]>.error(APIError.noConnection).delay(.milliseconds(200), scheduler: MainScheduler.instance)
        }
    }
}

extension String: Error {}
