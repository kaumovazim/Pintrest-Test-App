//
//  function.swift
//  Pintrest
//
//  Created by User on 12/01/22.
//

import Foundation

class Wishlist {
    
    public var wishlistItems: [wishlistModel] = []
   
    public func addWishlistItem(id: String, userName: String, image: String) {
        
        wishlistItems = getWishlist()
        
        wishlistItems.append(wishlistModel(id: id, userName: userName, imageUrl: image))
        
        let saveData = try? NSKeyedArchiver.archivedData(withRootObject: wishlistItems, requiringSecureCoding: false)
        UserDefaults.standard.setValue(saveData, forKey: "WishlistItems")
        UserDefaults.standard.synchronize()
    }

    public func getWishlist() -> [wishlistModel] {
        guard let data = UserDefaults.standard.object(forKey: "WishlistItems") as? Data,
        let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [wishlistModel] else {
            return []
        }
        return decodedModel
    }
    
    public func deleteWishlistItem (indexPath: Int) {
        wishlistItems = getWishlist()
        wishlistItems.remove(at: indexPath)
        let saveData = try? NSKeyedArchiver.archivedData(withRootObject: wishlistItems, requiringSecureCoding: false)
        UserDefaults.standard.setValue(saveData, forKey: "WishlistItems")
        UserDefaults.standard.synchronize()
    }
    
}

