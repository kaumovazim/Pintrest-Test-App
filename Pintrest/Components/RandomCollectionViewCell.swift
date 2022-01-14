//
//  RandomCollectionViewCell.swift
//  Pintrest
//
//  Created by User on 12/01/22.
//

import UIKit

class RandomCollectionViewCell: UICollectionViewCell {
    
    var photo: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray
        image.layer.cornerRadius = 25
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
            
    }
    
    func addViews() {
        addSubview(photo)
        photo.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        photo.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        photo.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photo.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
