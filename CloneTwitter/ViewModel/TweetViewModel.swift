//
//  TweetViewModel.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 27/03/21.
//

import UIKit

struct TweetViewModel {
    
    var user:User?
    var tweet: Tweet?
   
    
    var profileImageURL: URL? {
        guard let user = self.user else {return URL(string: String.init())}
        return user.profileImage
    }
    var timestamp: String {
        guard let tweet = tweet else {return String.init()}
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "30s"
    }
    
    func userInfoText() -> NSAttributedString {
        guard let user = self.user else {return NSAttributedString()}
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " · \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    
}
