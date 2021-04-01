//
//  ProfileViewController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 28/03/21.
//

import UIKit

class ProfileViewController: UICollectionViewController {
    
    //MARK: Properties
    private var user: User
    private var tweets = [Tweet]() {
        didSet { collectionView.reloadData()}
    }
    //MARK: Lifecycle
    
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        checkIfUserIsFollowed()
        fetchUsersStatus()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: API
    
    func fetchTweets(){
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
        }
    }
    
    func checkIfUserIsFollowed(){
        UserService.shared.checkIfUserIsFollowd(uid: user.uuid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUsersStatus(){
        UserService.shared.fetchUserStatus(uid: user.uuid) { stats in
            print("DEBUG: User Status")
            self.user.status = stats
            self.collectionView.reloadData()
        }
    }
    
    //MARK: Helpers
    func configureCollectionView(){
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(TweetViewCell.self, forCellWithReuseIdentifier: TweetViewCell.identifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeader.identifier)
    }
    
}
//MARK: UICollectionViewDataSource
extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetViewCell.identifier, for: indexPath) as! TweetViewCell
        let tweet = tweets[indexPath.row]
        cell.configure(tweet: tweet)
        return cell
    }
}

//MARK: UICollectionViewDelegate

extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeader.identifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}


//MARK: UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}


//MARK: ProfileHeaderDelegate

extension ProfileViewController: ProfileHeaderDelegate {
    func didTapEditProfile(_ header: ProfileHeader) {
        var buttonTitle:String = "Loading"
        var isFollowed: Bool = false
        
        if user.isCurrentUser {
            print("DEBUG: Showing the edit button. User can't follow or unfollow himself")
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uuid) { (err, ref) in
                self.user.isFollowed  = false
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
                self.fetchUsersStatus()
            }
        }
        else {
            UserService.shared.followUser(uid: user.uuid) { (err, ref) in
                self.user.isFollowed  = true
                header.editProfileFollowButton.setTitle("Following", for: .normal)
                self.fetchUsersStatus()
            }
        }
    }
    
    func didTapDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    
}
