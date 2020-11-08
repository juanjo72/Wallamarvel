//
//  LandingControllerFactory.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import UIKit

extension ViewControllerFactory {
    func makeHeroesController() -> UIViewController {
        let searchRepo = SearchRepository(api: api)
        let searchViewModel = SearchViewModel(repo: searchRepo)

        let repo = HeroesRepository(api: api)
        let viewModel = HeroesViewModel(repo: repo)
        let vc = HeroesController(viewModel: viewModel, resultsViewModel: searchViewModel)
        
        viewModel.didSelect = { [unowned self] heroe in
            let detailVC = self.makeHeroeDetail(id: heroe.id)
            vc.show(detailVC, sender: nil)
        }
        viewModel.didError = { [unowned vc] error in
            vc.display(error: error)
        }
        searchViewModel.didSelect = { heroe in
            let detailVC = self.makeHeroeDetail(id: heroe.id)
            vc.show(detailVC, sender: nil)
        }
        searchViewModel.didError = { [unowned vc] error in
            vc.display(error: error)
        }
        
        return vc
    }
}
