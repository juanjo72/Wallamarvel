//
//  HeroeDeteailTests+load.swift
//  WallamarvelTests
//
//  Created by Juanjo García Villaescusa on 06/11/2020.
//

import Quick
import Nimble
import RxBlocking
import API
@testable import Wallamarvel

extension HeroesDetailTests {
    internal func testLoad() {
        context("load") {
            beforeEach {
                let repo = HeroeDetailRepositoryStub(scenario: .sunnyDay)
                self.viewModel = HeroeDetailViewModel(repo: repo)
            }
            ckeckCover()
            ckeckName()
            checkAbout()
            checkSpinner()
        }
        context("error") {
            beforeEach {
                let repo = HeroeDetailRepositoryStub(scenario: .error)
                self.viewModel = HeroeDetailViewModel(repo: repo)
            }
            errorLoad()
        }
    }
    
    private func ckeckCover() {
        it("should issue cover") {
            self.viewModel.viewDidLoad()
            var url: URL?
            do {
                url = try self.viewModel.cover.take(1).toBlocking(timeout: 1).single()
            } catch {
                fail("ERROR \(error)")
                return
            }
            expect(url).to(equal(self.heroStub.thumbURL))
        }
    }
    
    private func ckeckName() {
        it("should issue name") {
            self.viewModel.viewDidLoad()
            var title: String?
            do {
                title = try self.viewModel.title.take(1).toBlocking(timeout: 1).single()
            } catch {
                fail("ERROR \(error)")
                return
            }
            expect(title).to(equal(self.heroStub.name))
        }
    }
    
    private func checkAbout() {
        it("should issue name") {
            self.viewModel.viewDidLoad()
            var about: String?
            do {
                about = try self.viewModel.about.take(1).toBlocking(timeout: 1).single()?.string
            } catch {
                fail("ERROR \(error)")
                return
            }
            expect(about).to(equal(self.heroStub.about))
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
    
    private func checkSpinner() {
        it("should activate and desactivate") {
            self.viewModel.viewDidLoad()
            let spinnerStates = try? self.viewModel.isLoading.share(replay: 1).take(2).toBlocking(timeout: 1).toArray()
            self.viewModel.viewDidLoad()
            expect(spinnerStates).to(equal([true, false]))
        }
    }
}
