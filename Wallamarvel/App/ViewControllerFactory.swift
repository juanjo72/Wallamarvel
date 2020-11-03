//
//  ViewControllerFactory.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import API

final class ViewFactoryController {
    
    unowned var api: API
    
    init(api: API) {
        self.api = api
    }
}
