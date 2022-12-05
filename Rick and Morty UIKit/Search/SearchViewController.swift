//
//  SearchViewController.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/4/22.
//

import UIKit

class SearchViewController: UICollectionViewController {
    
    var networkDataFetcher = NetworkDataFetcher()
    var posters = [Result]()
    private var timer: Timer? // делаем задержку в 0.5 сек

    // две кнопки для функционала в tab bar
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButton))
    }()
    
    private lazy var shareBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBarButton))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigationBar()
        setupSearchBar()
    }
    
    //MARK: - Navigation Items (Buttons)
    
    @objc private func addBarButton() {
        print(#function)
    }
    
    @objc private func shareBarButton() {
        print(#function)
    }

    func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
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
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
}

// метод отвечает за настройку конкретной ячейки
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
    cell.backgroundColor = .orange // временно
    return cell
}

//MARK: - UISearchBarDelegate Extension

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
        // weak self обязаткльно! - чтобы не было утечки памяти (тут функция в функции, перекрестные ссылки)
            self.networkDataFetcher.fetchCharacters(searchTerm: searchText, completion: { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                self?.posters = fetchedPhotos.results
                self?.collectionView.reloadData()

            })
                
//                self?.refresh()
//                self?.spinner.stopAnimating()
        })
    }
}
