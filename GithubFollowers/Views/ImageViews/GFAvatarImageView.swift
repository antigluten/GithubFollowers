//
//  GFAvatarImageView.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 17.05.2022.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    // MARK: REFACTOR
    let placeholderImage = UIImage(named: "avatar-placeholder")!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        contentMode = .scaleToFill
        image = placeholderImage
    }
    
    func setImage(with imageView: UIImageView) {
        self.image = imageView.image
    }

    // MARK: Refactor: Sean's code
    func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            guard error == nil else {
                return
            }
            
            guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }

            guard let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
        task.resume()
    }
}
