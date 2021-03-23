//
//  StorageManager.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 23/03/21.
//

import FirebaseStorage


public class StoreManager {
    static let shared = StoreManager()
    private let bucket = Storage.storage().reference()
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, Error>) -> Void){
        bucket.child(reference).downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(IGStorageManagerError.failedToDownload))
                return
            }
            completion(.success(url))
        })
    }
    
    public func uploadImage(with reference: String, data: Data, completion: @escaping(Result<String, Error>) -> Void) {
        bucket.child(reference).putData(data, metadata: nil) { (meta, error) in
            self.bucket.child(reference).downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {
                    completion(.failure(IGStorageManagerError.failedToDownload))
                    return
                }
                completion(.success(profileImageUrl))
            }
           
        }
    }
    
    
}

public enum IGStorageManagerError: Error {
    case failedToDownload
}

