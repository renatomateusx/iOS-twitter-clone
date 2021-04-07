//
//  ActionSheetViewModel.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 07/04/21.
//

import Foundation


struct ActionSheetViewModel {
    private let user: User
    private let tweet: Tweet?
    
    var options: [ActionSheetOptions]{
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            if let tweet = tweet {
                results.append(.delete(tweet))
            }
        }
        else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        if let tweet = tweet {
            results.append(.report(tweet))
        }
        
        return results
    }
    
    
    
    init(user: User, tweet: Tweet?){
        self.user = user
        self.tweet = tweet
    }
}


enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report(Tweet)
    case delete(Tweet)
    
    
    var description: String {
        switch self {
        
        case .follow(let user):
            return "Follow @\(user.username)"
        case .unfollow(let user):
            return "Unfollow @\(user.username)"
        case .report(let tweet):
            return "Report Tweet"
        case .delete(let tweet):
            return "Delete Tweet"
        }
    }
}
