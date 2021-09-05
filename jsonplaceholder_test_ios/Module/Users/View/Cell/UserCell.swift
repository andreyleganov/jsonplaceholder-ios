//
//  UserCell.swift
//  jsonplaceholder_test_ios
//
//  Created by Andrey Leganov on 9/4/21.
//

import UIKit

class UserCell: UITableViewCell {
    
    static var reuseIdentifier = "UserCell"
    
    // MARK: - View
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        
        return label
    }()
    
    // MARK: - Content
    func configureCell(_ user: User) {
        titleLabel.text = user.name
        emailLabel.text = user.email
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        contentView.addSubview(titleLabel)
        contentView.addSubview(emailLabel)
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        super.updateConstraints()
    }
}
