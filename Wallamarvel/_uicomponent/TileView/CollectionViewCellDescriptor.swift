//
//  File.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import UIKit

protocol CollectionViewCellDescriptable  {
    var cellDescriptor: CollectionViewCellDescriptor { get }
}

struct CollectionViewCellDescriptor {
    let cellClass: UICollectionViewCell.Type
    let reuseIdentifier: String
    let configure: (UICollectionViewCell) -> ()
    
    init<Cell: UICollectionViewCell>(reuseIdentifier: String, configure: @escaping (Cell) -> Void) {
        self.cellClass = Cell.self
        self.reuseIdentifier = reuseIdentifier
        self.configure = { cell in
            configure(cell as! Cell)
        }
    }
}
