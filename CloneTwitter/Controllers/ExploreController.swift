//
//  ExploreController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 22/03/21.
//

import UIKit


class ExploreViewController: UITableViewController, UIProtocols {

    //MARK: Properties
    
    private let config: ExploreConrollerConfiguration
    
    private var users = [User]() {
        didSet {tableView.reloadData()}
    }
    private var filteredUsers = [User]() {
        didSet {tableView.reloadData()}
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: Lifecycle
    
    init(withConfig config: ExploreConrollerConfiguration){
        self.config = config
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUsers()
        configureSearchUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: API
    func fetchUsers(){
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
    
    //MARK: Helpers
    func configureUI(){
        view.backgroundColor = .systemBackground
        navigationItem.title = config == .messages ? "New Message" : "Explore"
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        if config == .messages{
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelMessagesButton))
        }
    }
    
    func configureSearchUI(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Find someone!"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    //MARK: Selectors
    @objc func didTapCancelMessagesButton(){
        dismiss(animated: true, completion: nil)
    }
}


extension ExploreViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : self.users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = inSearchMode ? filteredUsers[indexPath.row] : self.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as! UserCell
        cell.configure(with: user)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : self.users[indexPath.row]
        let controller = ProfileViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ExploreViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        filteredUsers = users.filter({$0.username.contains(searchText)})
//        users.filter({$0.fullname.contains(searchText)})
    }
}
