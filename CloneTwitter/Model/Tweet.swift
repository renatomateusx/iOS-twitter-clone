//
//  Tweet.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 26/03/21.
//

import Foundation


struct Tweet {
    let text: String
    let tweetID: String
    let uid: String
    var likes: Int
    var timestamp: Date!
    let retweetCount: Int
    let user: User
    var didLiked = false
    var replyingTo: String?
    
    var isReply: Bool {return replyingTo != nil}
    
    init(user: User, tweetID: String, dictionary: [String: Any]){
        self.user = user
        self.tweetID = tweetID
        
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweets"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let replyingTo = dictionary["replyingTo"] as? String {
            self.replyingTo = replyingTo
        }
        
    }
}
