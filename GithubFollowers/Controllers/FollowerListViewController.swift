//
//  FollowerListViewController.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 14.05.2022.
//

import UIKit

class FollowerListViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var followers = [Follower]()
    
    // MARK: - Should refactor this section of code
    /// Force unwraping can cause a crash
    ///
    var username: String!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
        configureCollectionView()
        configureViewController()
        createDataSource()
        
        getFollowers()
    }
    
    func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Collection View
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
    
        view.addSubview(collectionView)
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)
        collectionView.backgroundColor = .systemBackground
        
        
    }
    
    // MARK: - CollectionViewFlowLayout
    
    func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width

        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (2 * minimumItemSpacing) - (2 * padding)
        let itemWidth = availableWidth / 3
        let labelHeight: CGFloat = 20
        let itemHeight: CGFloat = itemWidth + (2 * minimumItemSpacing) + labelHeight



        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
//        flowLayout.scrollDirection = .vertical
        
        return flowLayout
    }
    
    // MARK: - CollectionViewDiffableDataSource
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, follower in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.identifier, for: indexPath) as? FollowerCell else {
                    fatalError()
                }
                cell.set(follower: follower)
                
                return cell
            }
        )
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - LOGIC?
    
    func getFollowers() {
        NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] result in
            switch result {
            case .success(let followers):
                DispatchQueue.main.async {
                    self?.followers = followers
                    self?.updateData()
                }
            case .failure(let error):
                self?.presentGFAlertOnMainAlert(title: "Bad stuff", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}
