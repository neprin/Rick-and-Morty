//
//  EpisodesViewController.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/4/22.
//

import UIKit

class EpisodesViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    // настраваем navigation bar
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "All Episodes"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    }
    
    
    
}
