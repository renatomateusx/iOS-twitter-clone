//
//  UploadTweetController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 24/03/21.
//

import UIKit

class UploadTweetController: UIViewController {
    // MARK: Properties
    let user: User
    
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
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.setDimensions(width: 48, height: 48)
        image.layer.cornerRadius = 48 / 2
        image.backgroundColor = .white
        return image
    }()
    
    private let captionTextView = CaptionTextView()
    
    // MARK: Lifecycle
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Selectors
    @objc func didTapCancelButton(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapAddTweet(){
        guard let text = captionTextView.text else {return}
        TweetService.shared.uploadTweet(text: text) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload tweet with error \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: API
    
    
    
    // MARK: Helpers
    
    func configureUI(){
        view.backgroundColor = .white
       configureNavigationBar()
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        let padding: CGFloat = 16
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding)
        
        profileImageView.sd_setImage(with: user.profileImage, completed: nil)
    }
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.leftBarButtonItem = barButtonCancelTweet
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendTweet)
    }
}
