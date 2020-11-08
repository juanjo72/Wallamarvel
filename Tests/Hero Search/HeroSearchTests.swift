//
//  HeroSearchTests.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 07/11/2020.
//

import Quick
import WallamarvelKit
@testable import Wallamarvel

class HeroSearchTests: QuickSpec {
    var viewModel: SearchViewModel!
    
    override func spec() {
        describe("Heroes Search") {
            testLoad()
        }
    }
}
