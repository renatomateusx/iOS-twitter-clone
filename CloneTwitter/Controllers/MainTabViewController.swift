//
//  MainTabViewController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 22/03/21.
//

import UIKit
import Firebase

class MainTabViewController: UITabBarController, UIProtocols {
    
    //MARK: Properties
    var user: User?
    weak var delegateUser: UserDelegate?

    private let addTwitterButton: UIButton = {
       let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(didTapAddTwitter), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //logOut()
        authenticAndUserConfigureUI()
        
    }
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
            self.delegateUser?.setUser(user: user)
        }
    }
    
    func logOut(){
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("DEBUG: Error tried logout")
        }
    }
    
    func authenticAndUserConfigureUI(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
        else {
            print("DEBUG: User is logged in")
            configureUI()
            fetchUser()
        }
    }
    
    internal func configureUI(){
        view.backgroundColor = .systemBackground
        
        let feed = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = setTemplateNavController(image: "home_unselected", rootViewController: feed)
        
        let explore = ExploreViewController()
        let nav2 = setTemplateNavController(image: "search_unselected", rootViewController: explore)
        
        let notifications = NotificationsViewController()
        let nav3 = setTemplateNavController(image: "like_unselected", rootViewController: notifications)
        
        let messages = MessagesViewController()
        let nav4 = setTemplateNavController(image: "ic_mail_outline_white_2x-1", rootViewController: messages)
        
        
        viewControllers = [nav1, nav2, nav3, nav4]
        
        addSubViews()
        
    }
    
    private func addSubViews(){
        view.addSubview(addTwitterButton)
        let buttonSize: CGFloat = 56
        addTwitterButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: buttonSize, height: buttonSize)
        addTwitterButton.layer.cornerRadius = buttonSize / 2
    }
    
    private func setTemplateNavController(image: String, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = UIImage(named: image)
        nav.navigationBar.barTintColor = .white
        return nav
    }
}

extension MainTabViewController {
    @objc private func didTapAddTwitter(){
        guard let user = user else {return}
        let controllerTweet = UploadTweetController(user: user, config: .tweet)
        let nav = UINavigationController(rootViewController: controllerTweet)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}
