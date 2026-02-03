//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 01/02/26.
//

import UIKit
import LikeSwiftUI

class WelcomeViewController: UIViewController {

    private let signInButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        title = "Welcome to Spotify"
        view.backgroundColor = .systemBackground
        
        view.addSubview(signInButton)
        
        configureButton()
    }

    private func configureButton(){
        
        signInButton.frame(height: 50)
        signInButton.cornerRadius(15)
        signInButton.pin(leading: view.leadingAnchor,bottom: view.bottomAnchor,trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 20, bottom: 20, right: 20))
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    @objc func didTapSignIn(){
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    
    private func handleSignIn(success:Bool){
        if success{
            //User signed in
            let mainVC = TabBarViewController()
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true)
        }else{
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
}
