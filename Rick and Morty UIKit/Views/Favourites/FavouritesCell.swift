//
//  FavouritesCell.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/6/22.
//

import Foundation
import UIKit
import SDWebImage

class FavouritesCell: UICollectionViewCell {

    static let reuseId = "FavouritesCell"

    var favouriteImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var postersImage: Result! {
        didSet {
            let photoUrl = postersImage.image
            let imageUrl = photoUrl
            let url = URL(string: imageUrl)
            favouriteImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favouriteImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        setupImageView()
    }
    
//    func set(photo: Result) {
//        let photoUrl = photo.image
//        let photoURL = photoUrl
//        let url = URL(string: photoURL)
//        favouriteImageView.sd_setImage(with: url, completed: nil)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView() {
        addSubview(favouriteImageView)
        favouriteImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        favouriteImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        favouriteImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        favouriteImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
