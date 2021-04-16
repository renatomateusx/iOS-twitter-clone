//
//  TweetViewController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 05/04/21.
//

import UIKit

class TweetViewController: UICollectionViewController {
    //MARK: Properties
    private let tweet: Tweet
    private var actionSheet: ActionSheet?
    private var replies = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    //MARK: LifeCycle
    
    init(tweet: Tweet){
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchReplies()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Helpers
    func configureUI(){
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TweetViewCell.self, forCellWithReuseIdentifier: TweetViewCell.identifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TweetHeader.identifier)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else {return}
        collectionView.contentInset.bottom = tabHeight
    
    }
    
    fileprivate func showActionSheet(forUser user: User){
        actionSheet = ActionSheet(user: tweet.user, tweet: tweet)
        actionSheet?.delegate = self
        actionSheet?.showSheet()
    }
    
    
    //MARK: API
    func fetchReplies(){
        TweetService.shared.fetchReplies(forTweet: tweet) { replies in
            self.replies = replies
        }
    }
    
    //MARK: Selectors
}

//MARK: UICollectionViewDataSource
extension TweetViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetViewCell.identifier, for: indexPath) as! TweetViewCell
        cell.configure(tweet: replies[indexPath.row])
        return cell
    }
}
//MARK: UICollectionViewDelegate
extension TweetViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TweetHeader.identifier, for: indexPath) as! TweetHeader
        header.configure(tweet: tweet)
        header.delegate = self
        return header
    }
}

//MARK: UICollectionViewDelegateFlowLayout

extension TweetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = TweetViewModel(tweet: self.tweet)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        let plusHeight: CGFloat = 260
        return CGSize(width: view.frame.width, height: captionHeight + plusHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: self.tweet)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        let plusHeight: CGFloat = 72
        return CGSize(width: view.frame.width, height: captionHeight)
    }
}


//MARK: TweetHeaderDelegate
extension TweetViewController: TweetHeaderDelegate {
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { user in
            let controller = ProfileViewController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
   
    func showActionSheet() {
        if tweet.user.isCurrentUser {
            showActionSheet(forUser: tweet.user)
        }
        else {
            UserService.shared.checkIfUserIsFollowd(uid: tweet.user.uuid) { isFollowed in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
        
    }
    
}

//MARK: TweetViewController/ActionSheetDelegate
extension TweetViewController: ActionSheetDelegate {
    func didSelect(option: ActionSheetOptions) {
        print("DEBUG: Option selected is \(option.description)")
        
        switch option {
        
        case .follow(let user):
            UserService.shared.followUser(uid: user.uuid) { (err, ref) in
                print("DEBUG: Did follow user \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uuid) { (err, ref) in
                print("DEBUG: Did unfollow user \(user.username)")
            }
        case .report(let tweet):
            print("DEBUG: Report Twet \(tweet.text)")
        case .delete(let tweet):
            print("DEBUG: Delete Twet \(tweet.text)")
        }
    }
}
