//
//  MessagesController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 22/03/21.
//

import UIKit

class MessagesViewController: UIViewController, UIProtocols {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    internal func configureUI(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Messages"
    }

}
