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
    
    var usernameText: String {
        guard let username = user?.username else { return  String.init()}
        return "@\(username)"
    }
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a · MM/dd/yyyy"
        return formatter.string(from: (tweet?.timestamp)!)
    }
    
    var retweetsAttributedString: NSAttributedString? {
        guard let count = tweet?.retweetCount else { return NSAttributedString()}
        return attributeText(withValue: count, text: " Retweets")
    }
    
    var likesAttributedString: NSAttributedString? {
        guard let count = tweet?.likes else { return NSAttributedString()}
        return attributeText(withValue: count, text: " Likes")
    }
    
    var likeButtonTintColor: UIColor {
        guard let tweet = tweet else {return .lightGray}
        return tweet.didLiked ? .red : .lightGray
    }
    var likeButtonImage: UIImage {
        guard let tweet = tweet else {return UIImage(named: "like")!}
        let imageName = tweet.didLiked ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    var shouldHideReplyLabel: Bool {
        guard let tweet = self.tweet else {return true}
        return !tweet.isReply
    }
    
    var replyText: String? {
        guard let replyingToUser = tweet?.replyingTo else {return nil}
        return "→ replying to @\(replyingToUser)"
    }
    
    fileprivate func attributeText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet?.text
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    
    
}
