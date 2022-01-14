//
//  PhotoModelData.swift
//  Pintrest
//
//  Created by User on 12/01/22.
//

import Foundation

struct photoModel {
    
    var id: String
    var created_at : String
    var user: [userModel]
    var urls: [urlsModel]
    var location: [locationModel]
    var views: Int
    var downloads: Int
    
    init(dict: [String: Any]) {
        
        self.id = dict["id"] as? String ?? ""
        
        let createDate = dict["created_at"] as? String ?? ""
        let convertDate = convertDate(date: createDate)
        self.created_at = convertDate
        
        self.user = []
        self.user.append(userModel(dict: dict["user"] as! [String: Any]))
        
        self.urls = []
        self.urls.append(urlsModel(dict: dict["urls"] as! [String: Any]))
        
        self.location = []
        self.location.append(locationModel(dict: dict["location"] as? [String: Any] ?? [:]))
        
        self.views =  dict["views"] as? Int ?? 0
        
        self.downloads = dict["downloads"] as? Int ?? 0
        
    }
}

struct userModel {
    var username: String
    var name: String
    
    init(dict: [String: Any]) {
        self.username = dict["username"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
    }
}

struct locationModel {
    var name: String
    var city: String
    var country: String
    
    init(dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.city = dict["city"] as? String ?? ""
        self.country = dict["country"] as? String ?? ""
    }
}

struct urlsModel {
    var full: String
    var regular: String
    var small: String
    var thumb: String
    
    init(dict: [String: Any]) {
        self.full = dict["full"] as? String ?? ""
        self.regular = dict["regular"] as? String ?? ""
        self.small = dict["small"] as? String ?? ""
        self.thumb = dict["thumb"] as? String ?? ""
    }
}

class wishlistModel: NSObject, NSCoding {
    
    var id: String
    var userName: String
    var imageUrl: String
    
    init(id: String, userName: String, imageUrl: String) {
        self.id = id
        self.userName = userName
        self.imageUrl = imageUrl
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(userName, forKey: "userName")
        coder.encode(imageUrl, forKey: "imageUrl")
    }
    
    required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as? String ?? ""
        userName = coder.decodeObject(forKey: "userName") as? String ?? ""
        imageUrl = coder.decodeObject(forKey: "imageUrl") as? String ?? ""
    }
    
}

