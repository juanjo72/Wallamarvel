//
//  File.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import RxDataSources

struct AnimatableSection<Item: Equatable & RxDataSources.IdentifiableType> {
    var header: String?
    var items: [Item]
}

extension AnimatableSection: AnimatableSectionModelType {
    var identity: String {
        header ?? ""
    }
    
    init(original: Self, items: [Item]) {
        self.header = original.header
        self.items = items
    }
}
