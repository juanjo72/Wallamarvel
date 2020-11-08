//
//  HeroSearchTests+load.swift
//  WallamarvelTests
//
//  Created by Juanjo García Villaescusa on 07/11/2020.
//

import Quick
import Nimble
import RxBlocking
import API
@testable import Wallamarvel

extension HeroSearchTests {
    internal func testLoad() {
        context("search") {
            beforeEach {
                let repo = SearchRepositoryStub(scenario: .sunnyDay)
                self.viewModel = SearchViewModel(repo: repo)
            }
            checkFirstPageSerch()
            checkEmptySearchSerch()
            checkNextPageSearch()
            checkSpinner()
        }
        context("error") {
            beforeEach {
                let repo = SearchRepositoryStub(scenario: .error)
                self.viewModel = SearchViewModel(repo: repo)
            }
            errorLoad()
        }
    }
    
    private func checkFirstPageSerch() {
        it("should load 2 cards") {
            self.viewModel.viewDidLoad()
            self.viewModel.userDidType(search: "Captain America")
            let heroes = try? self.viewModel.cards.toBlocking(timeout: 2).first()
            expect(heroes?.count).to(equal(7))
        }
    }
    
    private func checkEmptySearchSerch() {
        it("should load 0 cards") {
            self.viewModel.viewDidLoad()
            self.viewModel.userDidType(search: "xxxx")
            let heroes = try? self.viewModel.cards.toBlocking(timeout: 2).first()
            expect(heroes?.count).to(equal(0))
        }
    }
    
    private func checkNextPageSearch() {
        it("next page load should load n cards") {
            self.viewModel.viewDidLoad()
            self.viewModel.userDidType(search: "Captain")
            var heroes = try? self.viewModel.cards.toBlocking(timeout: 10).first()
            self.viewModel.collectionViewDidReachEnd()
            heroes = try? self.viewModel.cards.toBlocking(timeout: 10).first()
            expect(heroes?.count).to(equal(15))
        }
    }
    
    private func checkSpinner() {
        it("should activate and desactivate") {
            self.viewModel.viewDidLoad()
            self.viewModel.userDidType(search: "Captain")
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
            self.viewModel.userDidType(search: "Captain")
            expect(e?.localizedDescription).toEventually(equal(APIError.noConnection.localizedDescription))
        }
    }
}
