//
//  Constants.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 24/03/21.
//

import Firebase

///Profile Images
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_image")

///Database
let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

///Tweets
let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user-tweets")
let REF_TWEET_REPLIES =  DB_REF.child("tweet-replies")


//User Follow Unfollow
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")


