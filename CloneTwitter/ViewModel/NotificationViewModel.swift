//
//  NotificationViewModel.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 08/04/21.
//

import UIKit

struct NotificationViewModel {
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var profileImageURL: URL? {
        return user.profileImage
    }
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: self.notification.timestamp, to: now) ?? "30s"
    }
    
    var notificationMesage: String {
        switch type {
        case .follow: return " started following you"
        case .like:  return " liked your tweet"
        case .reply: return " replied to your tweet"
        case .retweet: return " retweeted your tweet"
        case .mention: return " mentioned you in a tweet"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else {return nil}
        return attributeText(withValue: self.user.username, text: notificationMesage, auxText: timestamp)
        
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonText: String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    init(notification: Notification){
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
    
    fileprivate func attributeText(withValue value: String, text: String, auxText:String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        
        attributedTitle.append(NSAttributedString(string: " \(auxText)", attributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
