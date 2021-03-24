//
//  FeedControllerViewController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 22/03/21.
//

import UIKit
import SDWebImage

class FeedViewController: UIViewController, UIProtocols, UserDelegate {

    //MARK: Properties
    private var user: User?
    
    //MARK: Delegate
    func setUser(user: User) {
        self.user = user
        print("User was setted")
        changeUserImage()
    }
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        return imageView
    }()
    
    private let profileImageView: UIImageView = {        
        let profileImageView = UIImageView()
        //profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.layer.masksToBounds = true
        return profileImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDelegate()
    }
    func configureDelegate(){
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else {return}
        guard let controller = window.rootViewController as? MainTabViewController else {return}
        controller.delegateUser = self
    }
    
    internal func configureUI(){
        view.backgroundColor = .systemBackground
        
        navigationItem.titleView = logoImageView      
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
    private func changeUserImage(){
        guard let image = self.user?.profileImage else {return}
        profileImageView.sd_setImage(with: image, completed: nil)
    }
}
