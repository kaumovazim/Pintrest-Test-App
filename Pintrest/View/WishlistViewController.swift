//
//  WishlistViewController.swift
//  Pintrest
//
//  Created by User on 12/01/22.
//

import UIKit
import Alamofire

class WishlistViewController: UIViewController {
    
    let Access_Key = "kRcg8eZrgTBPGi3X4nFUURc4TVVOtJPB1T1aREiu97Y"
    
    let cellId = "wishlistCell"
    
    var wishlist = Wishlist()
    var wishlistItems: [wishlistModel] = []
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Избранное"
        
        addTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        parseData()
    }
    
    func addTableView() {
        tableView.register(WishlistTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func parseData() {
        self.wishlistItems = wishlist.getWishlist()
        self.tableView.reloadData()
    }
}

extension WishlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlistItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WishlistTableViewCell
        let imageUrlString = wishlistItems[indexPath.row].imageUrl
        
        if imageUrlString == "" {
            cell.photo.image = UIImage(systemName: "rays")
        } else {
            if let url = URL(string: imageUrlString) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        cell.photo.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
        cell.userName.text = wishlistItems[indexPath.row].userName
        cell.deleteItemButton.addTarget(self, action:#selector(deleteItem), for:.touchUpInside)
        cell.deleteItemButton.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            wishlistItems.remove(at: indexPath.row)
            wishlist.deleteWishlistItem(indexPath: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        getWishlistPhoto(indexPath: indexPath.row)
        
    }
    
    @objc func deleteItem (_ sender: Any) {
        let indexPath = IndexPath(item: (sender as AnyObject).tag, section: 0)
        tableView.beginUpdates()
        wishlistItems.remove(at: indexPath.row)
        wishlist.deleteWishlistItem(indexPath: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
        tableView.endUpdates()
        tableView.reloadData()
    }
    
    func getWishlistPhoto(indexPath: Int) {
        
        let showView = DetailsViewController()
        let photoId = wishlistItems[indexPath].id
        
        let queue = DispatchQueue.global(qos: .userInteractive); queue.async {
            
            let requestUrl = "https://api.unsplash.com/photos/\(photoId)?client_id=\(self.Access_Key)"
            
            if let encoded = requestUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
                
                AF.request(url).responseJSON { response in
                    
                    if let json = response.value as? [String: Any] {
                        
                        showView.collectionPhoto = []
                        
                        for photo in [json] {
                            
                            showView.collectionPhoto.append(photoModel(dict: photo))
                        }
                        
                        showView.addWishlistIcon.image = UIImage(systemName: "heart.fill")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.navigationController?.pushViewController(showView, animated: true)
                        }
                        
                    }
                }
            }
        }
    }
}


