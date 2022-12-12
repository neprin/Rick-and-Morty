//
//  SearchViewController.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/4/22.
//

import UIKit

class SearchViewController: UICollectionViewController {
    
    var networkDataFetcher = SearchDataFetcher()
    private var posters = [Result]() // массив в который будкм получать все постеры Rick&Morty
    private var timer: Timer? // делаем задержку в 0.5 сек
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private let itemsPerRow: CGFloat = 2
    private var selectedPosters = [UIImage]()
    
    // две кнопки для функционала в tab bar
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButton))
    }()
    
    private lazy var shareBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBarButton))
    }()
    
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigationBar()
        setupSearchBar()
        updateNavButtonsState()
    }
    
    private func updateNavButtonsState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        shareBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    func refresh() {
        self.selectedPosters.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavButtonsState()
    }
    
    //MARK: - Navigation Items (Buttons)
    
    @objc private func addBarButton() {
        print(#function)
        
        let selectedPosters = collectionView.indexPathsForSelectedItems?.reduce([], { (posterOne, indexPath) -> [Result] in
            var mutablePoster = posterOne
            let photo = posters[indexPath.item]
            mutablePoster.append(photo)
            return mutablePoster
        })
        
        let alertController = UIAlertController(title: "", message: "\(selectedPosters!.count) posters will be added to Favourites", preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            let tabbar = self.tabBarController as! MainTabBarController
            let navVC = tabbar.viewControllers?[3] as! UINavigationController
            let favouritesVC = navVC.topViewController as! FavouritesViewController
            
            favouritesVC.posters.append(contentsOf: selectedPosters ?? [])
            favouritesVC.collectionView.reloadData()
            self.refresh()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(add)
        alertController.addAction(cancel)
        present(alertController, animated: true)
        
    }
    
    @objc private func shareBarButton(sender: UIBarButtonItem) {
        print(#function)
        
        let shareIcon = UIActivityViewController(activityItems: selectedPosters, applicationActivities: nil)
        
        shareIcon.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        
        // для нормальной работе на ipad
        shareIcon.popoverPresentationController?.barButtonItem = sender
        shareIcon.popoverPresentationController?.permittedArrowDirections = .any
        present(shareIcon, animated: true, completion: nil)
    }
    
    func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.register(SearchPostersCell.self, forCellWithReuseIdentifier: SearchPostersCell.reuseId)
        
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    // настраваем navigation bar
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Search"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.rightBarButtonItems = [shareBarButtonItem, addBarButtonItem]
    }
    
    // настраиваем search bar
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        // чтобы сработал extension delegate
        searchController.searchBar.delegate = self
    }
    
    //MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters.count
    }
    
    // метод отвечает за настройку конкретной ячейки
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPostersCell.reuseId, for: indexPath) as! SearchPostersCell
        let postersPhoto = posters[indexPath.item]
        cell.postersPhoto = postersPhoto
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! SearchPostersCell
        guard let image = cell.posterImageView.image else { return }
        selectedPosters.append(image)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! SearchPostersCell
        guard let image = cell.posterImageView.image else { return }
        if let index = selectedPosters.firstIndex(of: image) {
            selectedPosters.remove(at: index)
        }
    }
}



//MARK: - UISearchBarDelegate Extension

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        // weak self обязательно! - чтобы не было утечки памяти
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchCharacters(searchTerm: searchText, completion: { [weak self] (searchResults) in
                searchResults?.results.map({ poster in
                    print(poster.image, poster.url)
                })
                guard let fetchedPhotos = searchResults else { return }
                self?.posters = fetchedPhotos.results
                self?.collectionView.reloadData()
                self?.refresh()
            })
        })
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let poster = posters[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let width = availableWidth / itemsPerRow
        let height = availableWidth / itemsPerRow
        return CGSize(width: width, height: height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
}
