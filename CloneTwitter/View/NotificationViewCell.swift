//
//  NotificationViewCell.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 08/04/21.
//

import UIKit

class NotificationViewCell: UITableViewCell {
    //MARK: Properties
    static let identifier = "NotificationViewCell"
    
    static let imageSize: CGFloat = 40
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: TweetViewCell.imageSize, height: TweetViewCell.imageSize)
        profileImageView.layer.cornerRadius = TweetViewCell.imageSize/2
        profileImageView.layer.masksToBounds = true
        profileImageView.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
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
    }
    func configure(){
        
    }
    
    //MARK: Selectors
    @objc func didTapProfileImage(){
        
    }
    
}
