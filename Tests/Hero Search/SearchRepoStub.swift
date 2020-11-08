//
//  SearchRepoStub.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 07/11/2020.
//

@testable import Wallamarvel
import WallamarvelKit
import RxSwift
import RxCocoa
import API

final class SearchRepositoryStub: SearchRepositoryType {
    
    
    enum Scenario {
        case sunnyDay
        case error
    }
    
    let scenario: Scenario
    
    lazy var heroes: [Hero] = {
        let url = Bundle(for: Self.self).url(forResource: "searchPool", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode([Hero].self, from: data)
    }()

    init(scenario: Scenario) {
        self.scenario = scenario
    }
    
    func fetchHeroes(search: String, page: Range<Int>) -> Single<[Hero]> {
        switch scenario {
        case .sunnyDay:
            let searchResults = heroes.filter { $0.name.starts(with: search) }
            let x = page.startIndex..<min(page.endIndex, searchResults.count)
            let searchResultsPage = searchResults[x]
            return Single<[Hero]>.just(Array(searchResultsPage)).delay(.milliseconds(100), scheduler: MainScheduler.instance)
        case .error:
            return Single<[Hero]>.error(APIError.noConnection).delay(.milliseconds(200), scheduler: MainScheduler.instance)
        }
    }
}
