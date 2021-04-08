//
//  NotificationsController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 22/03/21.
//

import UIKit

class NotificationsViewController: UITableViewController {

    
    //MARK: Properties
    private var notifications = [Notification]()
    
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    internal func configureUI(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationViewCell.self, forCellReuseIdentifier: NotificationViewCell.identifier)
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }

    //MARK: Selectors
    
   
    
    //MARK: API
}

extension NotificationsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationViewCell.identifier, for: indexPath) as! NotificationViewCell
        
        cell.configure()
        return cell
    }
}
