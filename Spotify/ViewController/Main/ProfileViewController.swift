//
//  ProfileViewController.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 09/02/26.
//

import UIKit
import LikeSwiftUI
import SDWebImage

class ProfileViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var models = [String]()
    
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
                updateUI(model: model)
            } catch {
                failedToGetProfile()
            }
        }
    }
    
    
    private func updateUI(model:UserProfile){
        tableView.isHidden = false
        models.append("Full Name: \(model.displayName)")
        models.append("Email: \(model.email)")
        models.append("User ID: \(model.id)")
        models.append("Plan: \(model.product)")
        createHeaderView(model: model.images.first?.url)
        tableView.reloadData()
    }
    
    private func createHeaderView(model:String?){
        guard let urlString = model, let url = URL(string: urlString) else {return}
        let headerView = UIView()
        let imageSize: CGFloat = headerView.frame.width / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center(in: headerView)
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)
        imageView.cornerRadius(imageSize / 2)

        tableView.tableHeaderView = headerView
        
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
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        return cell
    }
    
    
}
