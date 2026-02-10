//
//  ViewController.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 01/02/26.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        
        setUpNavBar()
        fetchData()
    }

    private func setUpNavBar(){
        let button = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(didProfileBtn))
        navigationItem.rightBarButtonItem = button
    }

    @objc private func didProfileBtn(){
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func fetchData(){
        Task{
           try await APICaller.shared.getNewReleases()
        }
    }
}

