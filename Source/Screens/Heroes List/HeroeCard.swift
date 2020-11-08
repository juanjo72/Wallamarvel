//
//  HeroeCard.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import WallamarvelKit
import RxDataSources

struct HeroeCard {
    let id: Int
    let url: URL?
}

extension HeroeCard: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension HeroeCard: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension HeroeCard: RxDataSources.IdentifiableType {
    var identity: Int {
        id
    }
}

extension HeroeCard: CustomDebugStringConvertible {
    var debugDescription: String {
        "\(id)"
    }
}

extension HeroeCard {
    init(heroe: Hero) {
        self.id = heroe.id
        self.url = heroe.thumbURL
    }
}

extension HeroeCard: CollectionViewCellDescriptable {
    var cellDescriptor: CollectionViewCellDescriptor {
        CollectionViewCellDescriptor(reuseIdentifier: "cell") { (cell: ImageCell) in
            cell.imageView.kf.setImage(with: url, placeholder: nil, options: [.waitForCache], progressBlock: nil) { result, error, type, url  in
                print(result)
            }
        }
    }
}

extension HeroeCard: Identifiable {
    var uniqueIdentifier: String {
        "\(id)"
    }
}
