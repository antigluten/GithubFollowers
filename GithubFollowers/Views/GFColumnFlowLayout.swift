//
//  ThreeColumnFlowLayout.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 18.05.2022.
//

import UIKit

class GFColumnFlowLayout: UICollectionViewFlowLayout {
    
    init(with width: CGFloat) {
        super.init()
        configure(width: width)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(width: CGFloat) {
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (2 * minimumItemSpacing) - (2 * padding)
        let itemWidth = availableWidth / 3
        let labelHeight: CGFloat = 20
        let itemHeight: CGFloat = itemWidth + (2 * minimumItemSpacing) + labelHeight

        sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
}
