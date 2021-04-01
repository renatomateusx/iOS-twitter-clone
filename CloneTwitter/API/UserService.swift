//
//  UserService.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 24/03/21.
//

import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping (User)-> Void) {
        DatabaseManager.shared.fetchUser(with: uid) { user in
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void){
        var users = [User]()
        REF_USERS.observe(.childAdded) {snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            let user = User(with: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)){
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentId).updateChildValues([uid: 1]) { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentId: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)){
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentId).removeValue { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowd(uid: String, completion: @escaping(Bool) -> Void){
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        REF_USER_FOLLOWING.child(currentId).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStatus(uid: String, completion: @escaping(UserRelationStats) -> Void){
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
            
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
}
