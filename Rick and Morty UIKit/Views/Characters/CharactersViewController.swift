//
//  CharactersViewController.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/4/22.
//

import UIKit
import Combine
import Resolver

class CharactersViewController: UIViewController {
   
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, RickAndMortyCharacter>!
    private var cancellables = Set<AnyCancellable>()
    private var isLoadingPage = false
    
    let charactersSubject = CurrentValueSubject<[RickAndMortyCharacter], Never>([])
    let isFirstLoadingPageSubject = CurrentValueSubject<Bool, Never>(true)
    var currentPage = 1
    var canLoadMorePages = true
    @LazyInjected private var networkService: NetworkService

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        configureDataSource()
        setViewModelListeners()
        Task {
            await getCharacters()
        }
    }
    
    func getCharacters() async {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        let request = CharactersRequest(page: currentPage)
        do {
            let characterResponseModel = try await networkService.fetch(request)
            isLoadingPage = false
            isFirstLoadingPageSubject.value = false
            if currentPage == 1 {
                charactersSubject.value.removeAll()
            }
            charactersSubject.value.append(contentsOf: characterResponseModel.results)
            if characterResponseModel.pageInfo.pages == currentPage {
                canLoadMorePages = false
                return
            }
            currentPage += 1
        } catch {
            if error != nil {
                print(error)
            }
            print(error.localizedDescription)
        }
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "All Characters"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PostersCell.self, forCellWithReuseIdentifier: PostersCell.reuseId)
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setViewModelListeners() {
        Publishers.CombineLatest(isFirstLoadingPageSubject, charactersSubject).sink { [weak self] (isLoading, characters) in
            DispatchQueue.main.async {
                    self?.createSnapshot(from: characters)
                    if characters.isEmpty {
                }
            }
        }
        .store(in: &cancellables)
    }
}

// MARK: - Collection View Data Source Configurations
extension CharactersViewController: UICollectionViewDelegate {
    fileprivate enum Section {
        case main
    }
    
    private func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, RickAndMortyCharacter>(collectionView: collectionView) {(collectionView, indexPath, characterModel) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostersCell.reuseId, for: indexPath) as? PostersCell
            cell?.set(with: characterModel)
            return cell
        }
    }
    
    private func createSnapshot(from addedCharacters: [RickAndMortyCharacter]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RickAndMortyCharacter>()
        snapshot.appendSections([.main])
        snapshot.appendItems(addedCharacters)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let collectionViewContentSizeHeight = collectionView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (collectionViewContentSizeHeight - scrollViewHeight) {
            Task {
                await getCharacters()
            }
        }
    }
}
