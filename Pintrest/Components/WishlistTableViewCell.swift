//
//  WishlistTableViewCell.swift
//  Pintrest
//
//  Created by User on 13/01/22.
//

import UIKit

class WishlistTableViewCell: UITableViewCell {
    
    var photo: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var userName: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 16)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    let deleteItemButton: UIButton = {
        let button = UIButton()
        var icon = UIImage(systemName: "trash")
        button.setImage(icon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        addViews()
    }
    
    func addViews() {
        contentView.addSubview(photo)
        photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        photo.heightAnchor.constraint(equalToConstant: 60).isActive = true
        photo.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        contentView.addSubview(userName)
        userName.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 20).isActive = true
        userName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        
        contentView.addSubview(deleteItemButton)
        deleteItemButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        deleteItemButton.leadingAnchor.constraint(equalTo: userName.trailingAnchor, constant: 10).isActive = true
        deleteItemButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
