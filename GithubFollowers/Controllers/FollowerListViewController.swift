//
//  FollowerListViewController.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 14.05.2022.
//

import UIKit

class FollowerListViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Follower>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Follower>
    
    enum Section {
        case main
    }
    
    
    var followers = [Follower]()
    var username: String
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)
        collectionView.backgroundColor = .systemBackground

        return collectionView
    }()
    
    lazy var dataSource = makeDataSource()
    
    init(with username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setup() {
        setupCollectionView()
        configureViewController()
        
        getFollowers()
    }
    
    func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - CollectionViewFlowLayout
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.frame = view.bounds
        collectionView.collectionViewLayout = GFColumnFlowLayout(in: view)
    }
    
    // MARK: - CollectionViewDiffableDataSource
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, follower in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.identifier, for: indexPath) as? FollowerCell else {
                    fatalError()
                }
                
                NetworkManager.shared.download(from: follower.avatarUrl) { result in
                    switch result {
                    case .success(let data):
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell.set(image: image)
                        }
                    case .failure(let error):
                        fatalError(error.rawValue)
                    }
                }
                
                cell.set(follower: follower)
                
                return cell
            }
        )
        
        return dataSource
    }
    
    func updateData() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - LOGIC?
    
    func getFollowers() {
        NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let followers):
                DispatchQueue.main.async {
                    self.followers = followers
                    self.updateData()
                }
            case .failure(let error):
                self.presentGFAlertOnMainAlert(title: "Bad stuff", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}
