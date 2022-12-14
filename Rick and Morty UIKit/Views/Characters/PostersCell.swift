//
//  PostersCell.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/4/22.
//

import UIKit
import SDWebImage

final class PostersCell: UICollectionViewCell {
 
    static let reuseIdentifier: String = "PostersCell"
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    private func addSubviews() {
        contentView.addSubview(posterImageView)
        posterImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    func set(with character: RickAndMortyCharacter) {
        guard let imageURL = URL(string: character.imageUrl) else { return }
        posterImageView.sd_setImage(with: imageURL)
    }
}

