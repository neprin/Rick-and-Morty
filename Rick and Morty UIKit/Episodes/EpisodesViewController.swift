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
    
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource: UITableViewDiffableDataSource<Section, Episode>!
    private var cancellables = Set<AnyCancellable>()
    var safeArea: UILayoutGuide!
    @LazyInjected private var episodesCell: EpisodesCell

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
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
                        if isLoading {
                        } else {
                            self?.createSnapshot(from: episodes)
                            if episodes.isEmpty {
                            } else {}
                        }
                    }
                }
                .store(in: &cancellables)
    }
}

// MARK: - Table View Data Source Configurations
extension EpisodesViewController: UITableViewDelegate {
    fileprivate enum Section {
        case main
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.constraintsForAnchoringTo(boundsOf: view))
    }
    
    private func configureDataSource(){
        dataSource = UITableViewDiffableDataSource<Section, Episode>(tableView: tableView) {(tableView, indexPath, episodeModel) -> UITableViewCell? in
            let cell = UITableViewCell()
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.text = "\(episodeModel.episodeCode) - \(episodeModel.name)"
            return cell
        }
    }
    
    private func createSnapshot(from addedEpisodes: [Episode]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Episode>()
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
























//import UIKit
//
//class EpisodesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    private let myArray: NSArray = ["First","Second","Third"]
//    private var myTableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
//        let displayWidth: CGFloat = self.view.frame.width
//        let displayHeight: CGFloat = self.view.frame.height
//
//        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
//        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
//        myTableView.dataSource = self
//        myTableView.delegate = self
//        self.view.addSubview(myTableView)
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Num: \(indexPath.row)")
//        print("Value: \(myArray[indexPath.row])")
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return myArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
//        cell.textLabel!.text = "\(myArray[indexPath.row])"
//        return cell
//    }
//}
