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
        let url: URL?
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
        self.url = heroe.thumbURL
    }
}

extension LandingViewModel.HeroeCard: CollectionViewCellDescriptable {
    var cellDescriptor: CollectionViewCellDescriptor {
        CollectionViewCellDescriptor(reuseIdentifier: "cell") { (cell: ImageCell) in
            cell.imageView.kf.setImage(with: self.url)
        }
    }
}

extension LandingViewModel.HeroeCard: Identifiable {
    var uniqueIdentifier: String {
        "\(id)"
    }
}
