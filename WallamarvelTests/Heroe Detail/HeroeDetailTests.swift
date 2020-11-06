//
//  HeroeDetailTests.swift
//  WallamarvelTests
//
//  Created by Juanjo García Villaescusa on 06/11/2020.
//

import Quick
import WallamarvelKit
@testable import Wallamarvel

class HeroesDetailTests: QuickSpec {

    var viewModel: HeroeDetailViewModel!
    
    lazy var heroe: Heroe = {
        let url = Bundle(for: Self.self).url(forResource: "heroe", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode(Heroe.self, from: data)
    }()
    
    override func spec() {
        describe("Heroe Detail") {
            testLoad()
        }
    }
}
