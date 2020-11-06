//
//  HeroesListTests.swift
//  WallamarvelTests
//
//  Created by Juanjo García Villaescusa on 06/11/2020.
//

import Quick
import WallamarvelKit
@testable import Wallamarvel

protocol HeroesViewModelType {
    var didSelect: ((Heroe) -> Void)? { get }
}

extension HeroesViewModel: HeroesViewModelType {}

final class HeroeViewModelMock: HeroesViewModelType {
    var selected: Heroe? = nil
    var didSelect: ((Heroe) -> Void)?
    
    init() {
        self.didSelect = { [unowned self] x in
            self.selected = x
        }
    }
}


class HeroesListTests: QuickSpec {
    var repo: HeroesRepositoryType!
    var viewModel: HeroesViewModel!
    
    override func spec() {
        describe("Heroes List") {
            testLoad()
            testSelection()
        }
    }
}
