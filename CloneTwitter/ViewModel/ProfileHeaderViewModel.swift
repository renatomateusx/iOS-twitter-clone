//
//  ProfileHeaderViewModel.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 29/03/21.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
//    case media
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
//        case .media: return "Media"
        }
    }
}

struct ProfileHeaderViewModel {
    private let user: User
    
    var usernameText: String
    
    var followersString: NSAttributedString? {
        return attributeText(withValue: user.status?.followers ?? 0, text: " Followers")
    }
    
    var followingString: NSAttributedString? {
        return attributeText(withValue: user.status?.following ?? 0, text: " Following")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        if !user.isFollowed && !user.isCurrentUser {
           return "Follow"
        }
        if user.isFollowed {
            return "Following"
        }
        return "Loading"
    }
    
    init(user: User){
        self.user = user
        self.usernameText = "@\(self.user.username)"
    }

    fileprivate func attributeText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
