//
//  Models.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 23/03/21.
//

import Foundation
import UIKit
import Firebase

struct Authentication {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct User {
    let uuid: String
    let email: String
    let fullname: String
    let username: String
    var profileImage: URL?
    var isFollowed = false
    var status: UserRelationStats?
    var isCurrentUser: Bool { Auth.auth().currentUser?.uid == uuid }
    
    init(with uuid: String){
        self.uuid = uuid
        self.email = String.init()
        self.fullname = String.init()
        self.username = String.init()
        self.profileImage = URL(string: String.init())
    }
    
    init(with uuid: String, dictionary: [String: AnyObject]){
        self.uuid = uuid
        
        let email = dictionary["email"] as? String ?? ""
        let username = dictionary["username"] as? String ?? ""
        let fullname = dictionary["fullname"] as? String ?? ""
        
        
        self.email = email
        self.username = username
        self.fullname = fullname
        
        self.profileImage = URL(string: String.init())
        if let profileImage = dictionary["profileImageUrl"] as? String {
            guard let url  = URL(string: profileImage) else {return}
            self.profileImage = url
        }
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
