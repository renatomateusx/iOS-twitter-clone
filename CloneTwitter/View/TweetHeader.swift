//
//  TweetHeader.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 05/04/21.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    //MARK: Properties
    static let identifier = "TweetHeader"
    private var tweet: Tweet?
    
    static let imageSize: CGFloat = 48
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
    
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Renato Mateus"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "@renatomateusx"
        return label
    }()
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Tweet Test"
        return label
    }()
    
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .lightGray
        label.text = "6:33 PM - 01/28/2021"
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.tintColor = .lightGray
//        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(didTapOptionsButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetsLabel = UILabel()
    
    private lazy var likesLabel = UILabel()
    
   
    private lazy var statsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        return view
    }()
    
    
    private lazy var commentButton: UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(didTapRetweetButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sharedButton: UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(didTapSharedButton), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    
    func configureUI(){
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stack)
        optionsButton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, height: 40)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, sharedButton])
        actionStack.spacing = 72
       
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(top: statsView.bottomAnchor, paddingTop: 16)
    }
    
    func configure(tweet: Tweet){
        self.tweet = tweet
        
        let viewModel = TweetViewModel(user: tweet.user, tweet: tweet)
        captionLabel.text = tweet.text
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        dateLabel.text = viewModel.headerTimestamp
        likesLabel.attributedText = viewModel.likesAttributedString
        retweetsLabel.attributedText = viewModel.retweetsAttributedString
    }
    
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    //MARK: Selectors
    
    @objc func didTapProfileImage(){
       
    }
    
    @objc func didTapCommentButton() {
        
    }
    
    @objc func didTapRetweetButton() {
        
    }
    
    @objc func didTapLikeButton() {
        
    }
    
    @objc func didTapSharedButton() {
        
    }
    
    @objc func didTapOptionsButton(){
        
    }
}
