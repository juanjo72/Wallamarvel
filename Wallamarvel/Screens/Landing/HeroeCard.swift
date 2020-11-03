//
//  HeroeCard.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import WallamarvelKit
import RxDataSources

extension LandingViewModel {
    struct HeroeCard {
        let id: Int
        let URL: URL?
    }
}

extension LandingViewModel.HeroeCard: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension LandingViewModel.HeroeCard: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension LandingViewModel.HeroeCard: RxDataSources.IdentifiableType {
    var identity: Int {
        id
    }
}

extension LandingViewModel.HeroeCard {
    init(heroe: Heroe) {
        self.id = heroe.id
        self.URL = heroe.thumbURL
    }
}
