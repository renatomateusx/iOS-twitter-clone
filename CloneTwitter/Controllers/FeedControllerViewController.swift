//
//  FeedControllerViewController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 22/03/21.
//

import UIKit

class FeedViewController: UIViewController, UIProtocols {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    internal func configureUI(){
        view.backgroundColor = .systemBackground
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}
