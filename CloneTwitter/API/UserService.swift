//
//  UserService.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 24/03/21.
//

import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping (User)-> Void) {
        DatabaseManager.shared.fetchUser(with: uid) { user in
            completion(user)
        }
    }
}
