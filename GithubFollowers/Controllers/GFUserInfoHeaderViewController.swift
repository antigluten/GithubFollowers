//
//  GFUserInfoHeaderViewController.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 25.05.2022.
//

import UIKit

class GFUserInfoHeaderViewController: UIViewController {
    
    private let avatarImageView = GFAvatarImageView(frame: .zero)
    private let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
    private let nameLabel = GFSecondaryTitleLabel(fontSize: 18)
    private let locationLabel = GFSecondaryTitleLabel(fontSize: 18)
    private let bioLabel = GFBodyLabel(textAlignment: .left)
    
    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: SFSymbols.location)
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    private var user: User
    
    private let padding: CGFloat = 20
    private let textImagePadding: CGFloat = 12
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        layoutUI()
        configureUIElements()
    }
    
    private func configureUIElements() {
        NetworkManager.shared.downloadImage(from: user.avatarUrl) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                self.avatarImageView.image = image
            case .failure(let error):
                print(error)
            }
        }
        
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? "No name"
        locationLabel.text = user.location ?? "No location"
        bioLabel.text = user.bio ?? "No bio available"
        bioLabel.numberOfLines = 3
    }
    
    private func layoutUI() {
        layoutAvatarImageView()
        layoutUsernameLabel()
        layoutNameLabel()
        layoutLocationImageView()
        layoutLocationLabel()
        layoutBioLabel()
    }
    
    private func layoutAvatarImageView() {
        view.addSubview(avatarImageView)
        
        let imageSize: CGFloat = 90
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: imageSize),
            avatarImageView.widthAnchor.constraint(equalToConstant: imageSize)
        ])
    }
    
    private func layoutUsernameLabel() {
        view.addSubview(usernameLabel)
        
        let heightSize: CGFloat = 40
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: heightSize)
        ])
    }
    
    private func layoutNameLabel() {
        view.addSubview(nameLabel)
        
        let heightSize: CGFloat = 22
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: heightSize)
        ])
    }
    
    private func layoutLocationImageView() {
        view.addSubview(locationImageView)
        
        let imageSize: CGFloat = 20
        
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: imageSize),
            locationImageView.heightAnchor.constraint(equalToConstant: imageSize)
        ])
    }
    
    private func layoutLocationLabel() {
        view.addSubview(locationLabel)
        
        let heightSize: CGFloat = 22
        
        NSLayoutConstraint.activate([
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: textImagePadding),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationLabel.heightAnchor.constraint(equalToConstant: heightSize)
        ])
    }
    
    private func layoutBioLabel() {
        view.addSubview(bioLabel)
        
        let heightSize: CGFloat = 60
        
        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            bioLabel.heightAnchor.constraint(equalToConstant: heightSize)
        ])
    }
}
