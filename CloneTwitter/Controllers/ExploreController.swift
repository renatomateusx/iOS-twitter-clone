//
//  ExploreController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 22/03/21.
//

import UIKit

class ExploreViewController: UITableViewController, UIProtocols {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    internal func configureUI(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Explore"
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
}


extension ExploreViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as! UserCell
        cell.configure()
        return cell
    }
}
