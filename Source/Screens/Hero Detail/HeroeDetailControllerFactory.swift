//
//  HeroeDetailControllerFactory.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 04/11/2020.
//

import UIKit

extension ViewControllerFactory {
    func makeHeroeDetail(id: Int) -> UIViewController {
        let repo = HeroeDetailRespository(heroeId: id, api: api)
        let viewModel = HeroeDetailViewModel(repo: repo)
        let vc = HeroeDetailViewController(viewModel: viewModel)
        
        return vc
    }
}
