//
//  MosaicViewLayout.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import UIKit

final class TileViewLayout: UICollectionViewLayout {
    
    let configuration: TileViewConfiguration
    
    override var collectionViewContentSize: CGSize {
        guard let _ = collectionView else { return .zero }
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    var tileSize: CGSize {
        let side: CGFloat = (collectionView?.bounds.width ?? 0) / CGFloat(configuration.numColumns)
        return CGSize(width: side, height: side)
    }
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var totalHeight: CGFloat = 0
    private var totalWidth: CGFloat = 0
    
    init(configuration: TileViewConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        guard let collectionView = self.collectionView else { return }
        guard collectionView.numberOfSections > 0 else { return }
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        guard numberOfItems > 0 else { return }
        cache.removeAll()
        totalHeight = 0
        var posX: CGFloat = 0
        for index in 0..<numberOfItems {
            let eachIndexPath = IndexPath(row: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: eachIndexPath)
            attributes.frame = CGRect(x: posX, y: totalHeight, width: tileSize.width, height: tileSize.height)
            posX += tileSize.width
            totalWidth = max(posX, totalWidth)
            cache.append(attributes)
            if (index + 1) % configuration.numColumns == 0 {
                totalHeight += tileSize.height
                posX = 0
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        cache.forEach { attributes in
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache[indexPath.row]
    }
}
