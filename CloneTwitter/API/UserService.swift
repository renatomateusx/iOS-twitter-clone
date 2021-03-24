//
//  UserService.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 24/03/21.
//

import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser(completion: @escaping (User)-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        DatabaseManager.shared.fetchUser(with: uid) { user in
            completion(user)
        }
    }
}
