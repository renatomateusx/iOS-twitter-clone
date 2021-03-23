//
//  DatabaseManager.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 23/03/21.
//


import FirebaseDatabase

public class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    // MARK: public functions
    
    /// Check if a username and email is available
    /// - Parameters
    ///     - email: String representing email
    ///     - password: String representing password
    public func canCreateNewUser(with email: String, username: String, completion: @escaping (Bool)-> Void){
        completion(true)
    }
    
    /// Insert new user into a database
    /// - Parameters
    ///     - email: String representing email
    ///     - password: String representing password
    ///     - completion: Async callback for result if database entry succeded
    public func updateUser(with uuid: String, values: [String: Any], completion: @escaping (Bool)-> Void){
        database.child(uuid).updateChildValues(values) { error, _ in
            if error == nil {
                //succeded
                completion(true)
                return
            }
            else {
                // failed
                completion(false)
                return
            }
        }
    }
    
  
}

