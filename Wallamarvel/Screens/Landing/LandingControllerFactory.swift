//
//  LandingControllerFactory.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import UIKit

extension ViewFactoryController {
    func makeLanding() -> UIViewController {
        let repo = LandingControllerRepository(api: api)
        let viewModel = LandingViewModel(repo: repo)
        let vc = LandingViewController(viewModel: viewModel)
        
        return vc
    }
}
