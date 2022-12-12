//
//  MainTabBarController.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/4/22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // делаем в нижнем TabBar: characters, episodes, search и favourites
        let charactersVC = CharactersViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let episodesVC = EpisodesViewController()
        let searchVC = SearchViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let favouritesVC = FavouritesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        viewControllers = [
            generateNavigationController(rootViewController: charactersVC, title: "Characters", Image: UIImage.init(systemName: "person.3.fill")!),
            generateNavigationController(rootViewController: episodesVC, title: "Episodes", Image: UIImage.init(systemName: "play.square.stack.fill")!),
            generateNavigationController(rootViewController: searchVC, title: "Search", Image: UIImage.init(systemName: "magnifyingglass")!),
            generateNavigationController(rootViewController: favouritesVC, title: "Favourites", Image: UIImage.init(systemName: "star.fill")!)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, Image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = Image
        return navigationVC
    }
}
