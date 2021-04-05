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
    
    //MARK: Helpers
    func configureUI(){
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TweetViewCell.self, forCellWithReuseIdentifier: TweetViewCell.identifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TweetHeader.identifier)
    
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
        return header
    }
}

//MARK: UICollectionViewDelegateFlowLayout

extension TweetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 280)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth: view.frame.width).height
        let plusHeight: CGFloat = 10
        return CGSize(width: view.frame.width, height: height + plusHeight)
    }
}
