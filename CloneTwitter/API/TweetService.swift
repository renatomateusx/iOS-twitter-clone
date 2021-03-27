//
//  TweetService.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 24/03/21.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(text: String, completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = ["uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970),
        "likes": 0, "retweets": 0, "text": text] as [String: Any]
        
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            guard let uuid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uuid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
}
