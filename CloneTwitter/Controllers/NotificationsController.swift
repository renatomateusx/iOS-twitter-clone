//
//  NotificationsController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 22/03/21.
//

import UIKit

class NotificationsViewController: UITableViewController {

    
    //MARK: Properties
    private var notifications = [Notification]() {
        didSet{
            tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    internal func configureUI(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationViewCell.self, forCellReuseIdentifier: NotificationViewCell.identifier)
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    //MARK: Selectors
    @objc func handleRefresh(){
        fetchNotifications()
    }
   
    
    //MARK: API
    func fetchNotifications(){
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotifications { notifications in
            self.notifications = notifications
            self.checkIfUserIsFollowd(notifications: self.notifications)
        }
        
        self.refreshControl?.endRefreshing()
    }
    
    func checkIfUserIsFollowd(notifications: [Notification]){
        for (index, notification) in notifications.enumerated(){
            if case .follow = notification.type {
                let user = notification.user
                UserService.shared.checkIfUserIsFollowd(uid: user.uuid) { isFollowed in
                    self.notifications[index].user.isFollowed = isFollowed
                }
            }
        }
    }
}
//MARK: NotificationsViewController/DataSource
extension NotificationsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationViewCell.identifier, for: indexPath) as! NotificationViewCell
       
        cell.configure(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}

//MARK: NotificationsViewController/Delegate

extension NotificationsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else {return}
        TweetService.shared.fetchTweet(withTweetID: tweetID) { tweet in
            let controller = TweetViewController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: NotificationsViewController/NotificationViewCellDelegate
extension NotificationsViewController: NotificationViewCellDelegate{
    
    func didTapFollowUnFollowButton(_ cell: NotificationViewCell) {
        guard var notification = cell.notification else {return}
        if notification.user.isFollowed {
            UserService.shared.unfollowUser(uid: notification.user.uuid) { (err, ref) in
                notification.user.isFollowed = false
                cell.configure(notification: notification)
            }
        }
        else{
            UserService.shared.followUser(uid: notification.user.uuid) { (err, ref) in
                notification.user.isFollowed = true
                cell.configure(notification: notification)
            }
        }
    }
    
    func didTapProfileImage(_ cell: NotificationViewCell) {
        guard let user = cell.notification?.user else {return}
        let controller = ProfileViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
