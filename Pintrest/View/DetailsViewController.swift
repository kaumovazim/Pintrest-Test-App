//
//  DetailsViewController.swift
//  Pintrest
//
//  Created by User on 13/01/22.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var collectionPhoto: [photoModel] = []
    var wishlist = Wishlist()
    
    lazy var widthScreen = view.frame.size.width
    lazy var heightScreen = view.frame.size.height
    
    lazy var photo: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray
        image.layer.cornerRadius = 15
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(addWishlist))
            doubleTap.numberOfTapsRequired = 2
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(doubleTap)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var userName: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 16)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    var createDate: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 16)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    var location: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 14)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    var views: UILabel = {
        let labale = UILabel()
        labale.translatesAutoresizingMaskIntoConstraints = false
        return labale
    }()
    
    var viewsIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "eye")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var downloadsIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "square.and.arrow.down.on.square")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var downloads: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 16)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    lazy var addWishlistIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "heart")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addWishlist))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizer)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 30
        
        navigationItem.title = "@" + collectionPhoto[0].user[0].username
        addViews()
        setData()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func addViews() {
        
        view.addSubview(photo)
        photo.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photo.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photo.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        photo.heightAnchor.constraint(equalToConstant: heightScreen - 250).isActive = true
        
        view.addSubview(addWishlistIcon)
        addWishlistIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addWishlistIcon.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: -60).isActive = true
        addWishlistIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addWishlistIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(createDate)
        createDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        createDate.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(downloads)
        downloads.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        downloads.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(downloadsIcon)
        downloadsIcon.trailingAnchor.constraint(equalTo: downloads.leadingAnchor, constant: -10).isActive = true
        downloadsIcon.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(userName)
        userName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        userName.topAnchor.constraint(equalTo: createDate.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(location)
        location.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        location.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 20).isActive = true
        
    }
    
    func setData() {
        
        let imageUrlString = collectionPhoto[0].urls[0].small
        
        if imageUrlString == "" {
            photo.image = UIImage(systemName: "rays")
        } else {
            if let url = URL(string: imageUrlString) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        self.photo.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
        
        createDate.text = collectionPhoto[0].created_at
        if collectionPhoto[0].downloads != 0 {
            downloads.text = "\(collectionPhoto[0].downloads)"
        } else {
            downloadsIcon.isHidden = true
            downloads.text = ""
        }
        userName.text = collectionPhoto[0].user[0].name
        location.text = collectionPhoto[0].location[0].name
    }
    
    @objc func addWishlist () {
        addWishlistIcon.image = UIImage(systemName: "heart.fill")
        saveData()
    }

    
    func saveData () {
        let queue = DispatchQueue.global(qos: .userInteractive); queue.async {
            self.wishlist.addWishlistItem(id:  self.collectionPhoto[0].id, userName:  self.collectionPhoto[0].user[0].name, image:  self.collectionPhoto[0].urls[0].small)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let alert = UIAlertController(title: "Избранное", message: "Фотография добавлена в список избранных", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Понятно", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }

}
