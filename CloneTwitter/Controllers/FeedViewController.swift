//
//  FeedControllerViewController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 22/03/21.
//

import UIKit
import SDWebImage

class FeedViewController: UICollectionViewController, UIProtocols, UserDelegate {

    //MARK: Properties
    private var user: User?
    private var tweets = [Tweet]() {
        didSet { collectionView.reloadData()}
    }
    
    //MARK: Delegate
    func setUser(user: User) {
        self.user = user
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
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDelegate()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: Helpers
    func configureDelegate(){
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else {return}
        guard let controller = window.rootViewController as? MainTabViewController else {return}
        controller.delegateUser = self
    }
    
    internal func configureUI(){
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TweetViewCell.self, forCellWithReuseIdentifier: TweetViewCell.identifier)
        
        navigationItem.titleView = logoImageView      
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
    private func changeUserImage(){
        guard let image = self.user?.profileImage else {return}
        profileImageView.sd_setImage(with: image, completed: nil)
    }
    
    //MARK: API
    func fetchTweets(){
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
            self.checkIfUserLikedTweets(self.tweets)
        }
    }
    
    func checkIfUserLikedTweets(_ tweets: [Tweet]){
        for (index, tweet) in tweets.enumerated() {
            TweetService.shared.checkIfUserLikedTweet(tweet) { didLiked in
                guard didLiked == true else {return}
                
                self.tweets[index].didLiked = true
            }
        }
    }
    
    //MARK: Selectors
}
//MARK: UICollectionViewDelegate/DataSource
extension FeedViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tweet = tweets[indexPath.row]
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetViewCell.identifier, for: indexPath) as! TweetViewCell
        cell.configure(tweet: tweet)
        cell.delegate = self
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweet = tweets[indexPath.row]
        let controller = TweetViewController(tweet: tweet)       
        navigationController?.pushViewController(controller, animated: true)
    }
}
//MARK: UICollectionViewDelegate/FlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        let plusHeight: CGFloat = 72
        return CGSize(width: view.frame.width, height: captionHeight + plusHeight)
    }
}

//MARK: TweetViewCellDelegate

extension FeedViewController: TweetViewCellDelegate {
    func didTapLikeTweet(_ cell: TweetViewCell) {
        guard let tweet = cell.tweet else {return}
        TweetService.shared.likeTweet(tweet: tweet) { (err, ref) in
            guard var tweet = cell.tweet else {return}
            tweet.didLiked.toggle()
            let likes = tweet.didLiked ? tweet.likes - 1 : tweet.likes + 1
            tweet.likes = likes
            cell.configure(tweet: tweet)
            
            guard tweet.didLiked else { return }
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
        }
    }
    
    func didTapReplyTweet(_ cell: TweetViewCell) {
        guard let tweet = cell.tweet else {return}
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func didTapProfileImage(_ cell: TweetViewCell) {
        guard let user = cell.user else {return}
        let controller = ProfileViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
