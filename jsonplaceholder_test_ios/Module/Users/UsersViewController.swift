//
//  UsersViewController.swift
//  jsonplaceholder_test_ios
//
//  Created by Andrey Leganov on 9/4/21.
//

import UIKit

class UsersViewController: UIViewController {
        
    private var users = [User]()
    private var loader = UsersLoader()
    private var mainView: UsersView! {
        return view as? UsersView
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = UsersView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
        
        getUsers()
    }
    
    // MARK: - Loading data
    private func getUsers() {
        loader.fetchUsers { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let users):
                self.users = users
                DispatchQueue.main.async {
                    self.mainView.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true)}
        
        let viewController = AlbumsViewController(userId: users[indexPath.row].id)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        cell.configureCell(users[indexPath.item])
        return cell
    }
}
