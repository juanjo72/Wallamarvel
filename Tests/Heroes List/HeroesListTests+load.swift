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
                let repo = HeroesRepoStub(scenario: .sunnyDay)
                self.viewModel = HeroesViewModel(repo: repo)
            }
            checkFirstPageLoad()
            checkNextPageLoad()
            checkSpinner()
        }
        context("error") {
            beforeEach {
                let repo = HeroesRepoStub(scenario: .error)
                self.viewModel = HeroesViewModel(repo: repo)
            }
            errorLoad()
        }
    }
    
    private func checkFirstPageLoad() {
        it("should load n cards") {
            self.viewModel.viewDidLoad()
            var heroes: [HeroeCard]?
            do {
                heroes = try self.viewModel.cards.toBlocking(timeout: 1).first()
            } catch {
                fail("ERROR \(error)")
                return
            }
            expect(heroes?.count).to(equal(.listPageSize))
        }
    }
    
    private func checkNextPageLoad() {
        it("next page load should load n cards") {
            self.viewModel.viewDidLoad()
            var heroes = try? self.viewModel.cards.take(1).toBlocking(timeout: 1).first()
            self.viewModel.collectionViewDidReachEnd()
            heroes = try? self.viewModel.cards.take(1).toBlocking(timeout: 1).first()
            expect(heroes?.count).to(equal(.listPageSize * 2))
        }
    }
    
    private func checkSpinner() {
        it("should activate and desactivate") {
            self.viewModel.viewDidLoad()
            let spinnerStates = try? self.viewModel.isLoading.share(replay: 1).take(2).toBlocking(timeout: 1).toArray()
            self.viewModel.viewDidLoad()
            expect(spinnerStates).to(equal([true, false]))
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
