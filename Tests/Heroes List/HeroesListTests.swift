//
//  HeroesListTests.swift
//  WallamarvelTests
//
//  Created by Juanjo García Villaescusa on 06/11/2020.
//

import Quick
import WallamarvelKit
@testable import Wallamarvel

class HeroesListTests: QuickSpec {
    var viewModel: HeroesViewModel!
    
    override func spec() {
        describe("Heroes List") {
            testLoad()
            testSelection()
        }
    }
}
