//
//  RandomViewController.swift
//  Pintrest
//
//  Created by User on 12/01/22.
//

import UIKit
import Alamofire

class RandomViewController: UIViewController {
    
    var collectionPhoto: [photoModel] = []
    var searchPhoto: [photoModel] = []
    
    let Access_Key = "kRcg8eZrgTBPGi3X4nFUURc4TVVOtJPB1T1aREiu97Y"
    
    private var cellId = "randomCell"
    
    var collectionView: UICollectionView!
    
    var searchController: UISearchController!
    private var resultsViewController = SearchResultViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Лента"
        view.backgroundColor = .systemGray
        
        addCollectionView()
        searchControllerSettings()
        getData()
    }
    
    func addCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: view.frame.width / 2 - 20, height: 300)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RandomCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        self.view.addSubview(collectionView)
    }
    
    func getData() {
        
        let queue = DispatchQueue.global(qos: .userInteractive); queue.async {
            
            let requestUrl = "https://api.unsplash.com/photos/random?count=30&client_id=\(self.Access_Key)"
            
            AF.request(requestUrl).responseJSON { response in
                if let json = response.value as? [[String: Any]] {
                    self.collectionPhoto = []
                    for photo in json {
                        self.collectionPhoto.append(photoModel(dict: photo))
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    
    func searchControllerSettings() {
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Найти ..."
        searchController.searchBar.keyboardType = .default
        searchController.searchBar.returnKeyType = UIReturnKeyType.search
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отменить"
    }
    
    func beginSearch(searchText: String) {
        
        let queue = DispatchQueue.global(qos: .userInteractive); queue.async {
            
            let requestUrl = "https://api.unsplash.com/search/photos?page=1&query=\(searchText)&client_id=\(self.Access_Key)"
            
            if let encoded = requestUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {
                
                AF.request(url).responseJSON { response in
                    
                    if let json = response.value as? [String: Any] {
                        let photos = json["results"] as? [[String: Any]] ?? []
                        self.searchPhoto = []
                        
                        for photo in photos {
                            self.searchPhoto.append(photoModel(dict: photo))
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.resultsViewController.updateFilteredData(array: self.searchPhoto)
                        self.resultsViewController.collectionView?.reloadData()
                    }
                }
            }
        }
    }
}

extension RandomViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RandomCollectionViewCell
        let imageUrlString = collectionPhoto[indexPath.row].urls[0].small
        
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let showView = DetailsViewController()
        showView.collectionPhoto.append(collectionPhoto[indexPath.row])
        navigationController?.pushViewController(showView, animated: true)
    }
    
}

extension RandomViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        beginSearch(searchText: searchController.searchBar.text!)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchPhoto = []
        self.resultsViewController.updateFilteredData(array: self.searchPhoto)
        self.resultsViewController.collectionView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
    }
    
}

