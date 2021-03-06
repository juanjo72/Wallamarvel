//
//  HeroesListTests+selection.swift
//  WallamarvelTests
//
//  Created by Juanjo García Villaescusa on 06/11/2020.
//

import Quick
import Nimble
import RxBlocking
import WallamarvelKit
@testable import Wallamarvel

extension HeroesListTests {
    internal func testSelection() {
        context("selection") {
            beforeEach {
                let repo = HeroesRepoStub(scenario: .sunnyDay)
                self.viewModel = HeroesViewModel(repo: repo)
            }
            selection()
        }
    }
    
    private func selection() {
        it("should call handler") {
            self.viewModel.viewDidLoad()
            var heroes: [HeroeCard]?
            do {
                heroes = try self.viewModel.cards.toBlocking(timeout: 1).first()
            } catch {
                fail("ERROR \(error)")
                return
            }
            var selected: Hero?
            self.viewModel.didSelect = { heroe in
                selected = heroe
            }
            self.viewModel.didSelect(item: heroes!.first!)
//            self.viewModel.didSelect(item: heroes!.first!)
            expect(heroes?.first?.id).toEventually(equal(selected?.id))
        }
    }
}
