//
//  TweetViewCellCollectionViewCell.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 26/03/21.
//

import UIKit
import SDWebImage

protocol TweetViewCellDelegate: class {
    func didTapProfileImage(_ cell: TweetViewCell)
}

class TweetViewCell: UICollectionViewCell  {
    // MARK: Properties
    static let identifier = "TweetViewCell"
    var user: User?
    weak var delegate: TweetViewCellDelegate?
    
    static let imageSize: CGFloat = 32
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: TweetViewCell.imageSize, height: TweetViewCell.imageSize)
        profileImageView.layer.cornerRadius = TweetViewCell.imageSize/2
        profileImageView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
        
        return profileImageView
    }()
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Tweet Test"
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(didTapRetweetButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sharedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(didTapSharedButton), for: .touchUpInside)
        return button
    }()
    
    private let infoLabel = UILabel()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 8)
        
        let stack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
       
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        addSubview(stack)
        stack.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        
        infoLabel.text = "Renato Moura"
        captionLabel.text =  "Testezin"
        
        let actiontack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, sharedButton])
        actiontack.axis = .horizontal
        actiontack.spacing = 72
        
        addSubview(actiontack)
        actiontack.centerX(inView: self)
        actiontack.anchor(bottom: bottomAnchor, paddingBottom: 8)
        
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Selectors
    
    @objc func didTapCommentButton() {
        
    }
    
    @objc func didTapRetweetButton() {
        
    }
    
    @objc func didTapLikeButton() {
        
    }
    
    @objc func didTapSharedButton() {
        
    }
    
    @objc func didTapProfileImage(){
        delegate?.didTapProfileImage(self)
    }
    
    // MARK: Helpers
    
    func configure(tweet: Tweet){
        self.user = tweet.user
        let viewM = TweetViewModel(user: tweet.user, tweet: tweet)
        self.profileImageView.sd_setImage(with: tweet.user.profileImage, completed: nil)
        self.infoLabel.attributedText = viewM.userInfoText()
        self.captionLabel.text = tweet.text
    }
    
}
