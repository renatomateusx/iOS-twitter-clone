//
//  Notification.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 08/04/21.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    var tweetID: String?
    var timestamp: Date!
    var user: User
    var tweet: Tweet?
    var type: NotificationType!
    
    init(user: User, tweet: Tweet? = nil, dictionary: [String : AnyObject]){
        self.user = user
        if let tweet = tweet {
            self.tweet = tweet
        }
        if let tweetID = dictionary["tweetID"] as? String {
            self.tweetID = tweetID
        }
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
