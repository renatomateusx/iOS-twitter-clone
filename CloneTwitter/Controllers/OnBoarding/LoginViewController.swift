//
//  LoginViewController.swift
//  CloneTwitter
//
//  Created by Renato Mateus on 22/03/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    private let logoImageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = #imageLiteral(resourceName: "TwitterLogo")
        return image
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Components().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Components().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Components().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Components().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Components().attributedButton("Don't have an account?", " Sign Up")
        button.addTarget(self, action: #selector(didTapDontHaveAccount), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
   
    
    // MARK: Selectors
    
    @objc private func didTapLoginButton(){
        print("Did login button tapped")
    }
    
    @objc private func didTapDontHaveAccount(){
        let vc = RegistrationViewController()
        navigationController?.pushViewController(vc, animated: true)
        //vc.modalPresentationStyle = .fullScreen
        //present(vc, animated: true, completion: nil)
    }
    
    // MARK: Helpers
    
    private func configureUI(){
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        let paddingSize: CGFloat = 16
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: paddingSize, paddingRight: paddingSize)
        
        view.addSubview(dontHaveAccountButton)
        let paddingSizeButton: CGFloat = 40
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: paddingSizeButton, paddingBottom: 16, paddingRight: paddingSizeButton)
    }
    

}
