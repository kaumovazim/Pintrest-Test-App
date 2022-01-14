//
//  SearchResultViewController.swift
//  Pintrest
//
//  Created by User on 13/01/22.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    lazy var widthScreen = view.frame.size.width
    
    var photo: [photoModel] = []
    
    var collectionView: UICollectionView!
    private var cellId = "searchResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aadCollectionView()
        
    }
    
    func aadCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            layout.itemSize = CGSize(width: widthScreen / 2 - 20, height: 300)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        self.view.addSubview(collectionView)
    }
    
    func updateFilteredData(array: Array<photoModel>) {
        photo = array
    }

}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCollectionViewCell
        let imageUrlString = photo[indexPath.row].urls[0].small
        
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
        showView.collectionPhoto.append(photo[indexPath.row])
        present(showView, animated: true, completion: nil)
    }
    
}
