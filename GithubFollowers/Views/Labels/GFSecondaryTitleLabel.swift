//
//  GFSecondaryTitleLabel.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 25.05.2022.
//

import UIKit

class GFSecondaryTitleLabel: UILabel {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        
        font = .systemFont(ofSize: fontSize, weight: .medium)
        
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        lineBreakMode = .byTruncatingTail
        minimumScaleFactor = 0.9
    }
}
