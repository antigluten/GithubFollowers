//
//  ThreeColumnFlowLayout.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 18.05.2022.
//

import UIKit

class GFColumnFlowLayout: UICollectionViewFlowLayout {
    
    init(in view: UIView) {
        super.init()
        configure(in: view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(in view: UIView) {
        let width = view.bounds.width
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
