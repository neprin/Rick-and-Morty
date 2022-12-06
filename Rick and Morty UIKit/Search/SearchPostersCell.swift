//
//  SearchPostersCell.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/6/22.
//

import UIKit
import SDWebImage

class SearchPostersCell: UICollectionViewCell {
    
    static let reuseId = "SearchPostersCell"
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var postersPhoto: Result! {
        didSet {
            let posterUrl = postersPhoto.image
            let imageUrl = posterUrl
            let url = URL(string: imageUrl)
            posterImageView.sd_setImage(with: url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPhotoImageView()
        setupCheckmarkView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectedCheckmark()
        }
    }
    
    private func updateSelectedCheckmark() {
        posterImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    //MARK: - Checkmark For Poster
    // делаем галочку для выбора фота для добавления в избранное
    private let checkmark: UIImageView = {
        let image = UIImage(systemName: "checkmark.circle.fill")
        let imageView = UIImageView(image: image)
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // закрепим с помощью якорей гплочку на фото
    private func setupPhotoImageView() {
        addSubview(posterImageView)
        posterImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
    }
    
    private func setupCheckmarkView() {
        addSubview(checkmark)
        checkmark.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -10).isActive = true
        checkmark.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -10).isActive = true
    }
    
}
