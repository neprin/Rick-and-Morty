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

    var myImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .green
        return imageView
    }()
    
    var postersImage: Result! {
        didSet {
            let photoUrl = postersImage.image
            let imageUrl = photoUrl
            let url = URL(string: imageUrl)
            myImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        setupImageView()
    }
    
    func setupImageView() {
        addSubview(myImageView)
        myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        myImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        myImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        myImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func set(photo: Result) {
        let photoUrl = photo.image
        let photoURL = photoUrl
        let url = URL(string: photoURL)
        myImageView.sd_setImage(with: url, completed: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
