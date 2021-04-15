//
//  UploadTweetController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 24/03/21.
//

import UIKit
import ActiveLabel



class UploadTweetController: UIViewController {
    // MARK: Properties
    let user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    private lazy var barButtonCancelTweet: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
        return button
    }()
    
    private lazy var sendTweet: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(didTapAddTweet), for: .touchUpInside)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.setDimensions(width: 48, height: 48)
        image.layer.cornerRadius = 48 / 2
        image.backgroundColor = .white
        return image
    }()
    
    private lazy var replyLabel: ActiveLabel = {
       let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "replying to @rufino"
        label.mentionColor = .twitterBlue
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let captionTextView = CaptionTextView()
    
    // MARK: Lifecycle
    
    init(user: User, config: UploadTweetConfiguration){
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMentionHandler()
    }
    
    // MARK: Selectors
    @objc func didTapCancelButton(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapAddTweet(){
        guard let text = captionTextView.text else {return}
        TweetService.shared.uploadTweet(text: text, type: config) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload tweet with error \(error.localizedDescription)")
                return
            }
            
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: API
    
    
    
    // MARK: Helpers
    
    func configureUI(){
        view.backgroundColor = .white
       configureNavigationBar()
        
        let stackCaption = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stackCaption.axis = .horizontal
        stackCaption.spacing = 12
        stackCaption.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, stackCaption])
        stack.axis = .vertical
        //stack.alignment = .leading
        stack.spacing = 12
        
        view.addSubview(stack)
        let padding: CGFloat = 16
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding)
        
        profileImageView.sd_setImage(with: user.profileImage, completed: nil)
        sendTweet.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else {return}
        replyLabel.text = replyText
    }
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.leftBarButtonItem = barButtonCancelTweet
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendTweet)
    }
    
    func configureMentionHandler(){
        replyLabel.handleMentionTap { mention in
            print("DEBUG: Mentioned user is \(mention)")
        }
    }
}
