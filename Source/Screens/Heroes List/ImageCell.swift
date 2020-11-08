//
//  ImageCell.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import SnapKit
import Kingfisher

final class ImageCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
