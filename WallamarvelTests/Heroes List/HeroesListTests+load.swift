//
//  HeroesListTests+load.swift
//  WallamarvelTests
//
//  Created by Juanjo García Villaescusa on 06/11/2020.
//

import Quick
import Nimble
import RxBlocking
import API
@testable import Wallamarvel

extension HeroesListTests {
    internal func testLoad() {
        context("load") {
            beforeEach {
                self.repo = HeroesRepoStub(scenario: .sunnyDay)
                self.viewModel = HeroesViewModel(repo: self.repo)
            }
            firstLoad()
            nextPage()
        }
        context("error") {
            beforeEach {
                let repo = HeroesRepoStub(scenario: .error)
                self.viewModel = HeroesViewModel(repo: repo)
            }
            errorLoad()
        }
    }
    
    private func firstLoad() {
        it("should load n cards") {
            self.viewModel.viewDidLoad()
            var heroes: [HeroeCard]?
            do {
                heroes = try self.viewModel.cards.toBlocking(timeout: 10).first()
            } catch {
                fail("ERROR \(error)")
                return
            }
            expect(heroes?.count).to(equal(25))
        }
    }
    
    private func nextPage() {
        it("next page load should load n cards") {
            self.viewModel.viewDidLoad()
            self.viewModel.collectionViewDidReachEnd()
            var heroes: [HeroeCard]?
            do {
                heroes = try self.viewModel.cards.skip(1).toBlocking(timeout: 10).first()
            } catch {
                fail("ERROR \(error)")
                return
            }
            expect(heroes?.count).to(equal(25))
        }
    }
    
    private func errorLoad() {
        it("should call error handler") {
            var e: APIError?
            self.viewModel.didError = { error in
                e = error as? APIError
            }
            self.viewModel.viewDidLoad()
            expect(e?.localizedDescription).to(equal(APIError.noConnection.localizedDescription))
        }
    }
}
