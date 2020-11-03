//
//  LandingControllerFactory.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import UIKit

extension ViewFactoryController {
    func makeLanding() -> UIViewController {
        api.fetchHeroes(page: 0..<10) { result in
            switch result {
            case .success(let values):
                print(values.map { $0.name })
            case .failure(_):
                break
            }
        }
        
        return UIViewController()
    }
}
