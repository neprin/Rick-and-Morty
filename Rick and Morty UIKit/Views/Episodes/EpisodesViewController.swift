//
//  EpisodesViewController.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/4/22.
//

import UIKit
import Combine
import Resolver

class EpisodesViewController: UIViewController {
    
    @UsesAutoLayout
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var dataSource: UITableViewDiffableDataSource<Section, EpisodeResult>!
    private var cancellables = Set<AnyCancellable>()
//    var safeArea: UILayoutGuide!
    @LazyInjected private var episodesCell: EpisodesCell

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
        setupDataSource()
        setViewModelListeners()
        Task {
            await episodesCell.getEpisodes()
        }
    }
    
    // настраваем navigation bar
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "All Episodes"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    }
    
    private func setViewModelListeners() {
                Publishers.CombineLatest(episodesCell.isFirstLoadingPageSubject, episodesCell.episodesSubject).sink { [weak self] (isLoading, episodes) in
                    DispatchQueue.main.async {
                            self?.createSnapshot(from: episodes)
                            if episodes.isEmpty { return }
                    }
                }
                .store(in: &cancellables)
    }
}

// MARK: - Table View Configurations
extension EpisodesViewController: UITableViewDelegate {
    fileprivate enum Section {
        case main
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.constraintsForAnchoringTo(boundsOf: view))
    }
    
    // настраиваем как будет отображаться одна ячейка Episode
    private func setupDataSource(){
        dataSource = UITableViewDiffableDataSource<Section, EpisodeResult>(tableView: tableView) {
            (tableView, indexPath, episodeModel) -> UITableViewCell? in
            let cell = UITableViewCell()
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.text = "\(episodeModel.episode) - \(episodeModel.name)"
            return cell
        }
    }
    
    private func createSnapshot(from addedEpisodes: [EpisodeResult]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, EpisodeResult>()
        snapshot.appendSections([.main])
        snapshot.appendItems(addedEpisodes)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let tableViewContentSizeHeight = tableView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (tableViewContentSizeHeight - scrollViewHeight) {
            Task {
                await episodesCell.getEpisodes()
            }
        }
    }
}

extension UIView {
    
    /// Returns a collection of constraints to anchor the bounds of the current view to the given view.
    ///
    /// - Parameter view: The view to anchor to.
    /// - Returns: The layout constraints needed for this constraint.
    func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }
}
