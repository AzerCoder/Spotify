//
//  ProfileViewController.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 09/02/26.
//

import UIKit
import LikeSwiftUI

class ProfileViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        title = "Profile"
        
        navigationItem.largeTitleDisplayMode = .never
        
        fetchData()
        configureTableView()
    }
    
    private func configureTableView(){
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.edgesToSuperview()
    }
    
    
    @MainActor
    private func fetchData() {
        Task {
            do {
                let model = try await APICaller.shared.getCurrentUserProfile()
                updateUI(with: model)
            } catch {
                failedToGetProfile()
            }
        }
    }

    
    private func updateUI(with:UserProfile){
        tableView.isHidden = false
        
        tableView.reloadData()
    }
    
    private func failedToGetProfile(){
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center(in: view)
    }

}


extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Test"
        return cell
    }
    
    
}
