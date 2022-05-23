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
    lazy var filteredFollowers = [Follower]()
    var username: String
    var page = 1

    var hasMoreFollowers = true

    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)

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

        configureViewController()
    }

    func setup() {
        setupSearchController()
        setupCollectionView()
        configureViewController()

        // get followers
        getFollowers(username: username, page: page)
    }

    func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    }
    
    func setupSearchController() {
        let searchVC = UISearchController()
        searchVC.searchBar.placeholder = "Search for a username"
        searchVC.searchResultsUpdater = self
        searchVC.searchBar.delegate = self
        searchVC.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    // MARK: - CollectionViewFlowLayout

    func setupCollectionView() {
        
        view.addSubview(collectionView)

        collectionView.delegate = self

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
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

                NetworkManager.shared.downloadImage(from: follower.avatarUrl) { result in
                    switch result {
                    case .success(let image):
                        DispatchQueue.main.async {
                            cell.set(image: image)
                        }
                    case .failure(let error):
                        print(error.rawValue)
                    }
                }

                cell.set(follower: follower)

                return cell
            }
        )
        
        return dataSource
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - LOGIC?

    func getFollowers(username: String, page: Int) {
        showLoadingView()
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                DispatchQueue.main.async {
                    self.followers += followers
                    if self.followers.isEmpty {
                        let message = "This used doesn't have any followers"
                        self.showEmptyStateView(with: message, in: self.view)
                        return
                    }
                    self.updateData(on: self.followers)
                }
            case .failure(let error):
                self.presentGFAlertOnMainAlert(title: "Bad stuff", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FollowerListViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        let height = scrollView.frame.height
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else {
                print("There are no more followers")
                return
            }
            page += 1
            print("Incrementing page \(page)")
            getFollowers(username: username, page: page)
        }
    }
}

extension FollowerListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            return
        }
        
        filteredFollowers = followers.filter { follower in
            follower.login.lowercased().contains(filter.lowercased())
        }
        
        updateData(on: filteredFollowers)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: followers)
    }
    
}
