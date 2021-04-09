//
//  NotificationViewCell.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 08/04/21.
//

import UIKit
import SDWebImage

protocol NotificationViewCellDelegate: class {
    func didTapProfileImage(_ cell: NotificationViewCell)
    func didTapFollowUnFollowButton(_ cell: NotificationViewCell)
}

class NotificationViewCell: UITableViewCell {
    //MARK: Properties
    static let identifier = "NotificationViewCell"
    var notification:Notification?
    weak var delegate: NotificationViewCellDelegate?
    
    static let imageSize: CGFloat = 40
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: TweetViewCell.imageSize, height: TweetViewCell.imageSize)
        profileImageView.layer.cornerRadius = TweetViewCell.imageSize/2
        profileImageView.layer.masksToBounds = true
        profileImageView.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        tap.cancelsTouchesInView = true
        tap.numberOfTouchesRequired = 1
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
       
        
        return profileImageView
    }()
    
    let notificationlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Tested your notification"
    
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(didTapFollowUnFollowButton), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configureUI(){
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationlabel])
        stack.spacing = 8
        stack.alignment = .center
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        stack.anchor(right: rightAnchor, paddingRight: 12)
        
        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(width: 92, height: 32)
        followButton.layer.cornerRadius = 32 / 2
        followButton.anchor(right: rightAnchor, paddingRight: 12)
    }
    func configure(notification: Notification){
        self.notification = notification
        let viewModel = NotificationViewModel(notification: notification)
        
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        notificationlabel.attributedText = viewModel.notificationText
        followButton.isHidden = viewModel.shouldHideFollowButton
        followButton.setTitle(viewModel.followButtonText, for: .normal)
    }
    
    //MARK: Selectors
    @objc func didTapProfileImage(){
        delegate?.didTapProfileImage(self)
    }
    
    @objc func didTapFollowUnFollowButton(){
        delegate?.didTapFollowUnFollowButton(self)
    }
    
}
