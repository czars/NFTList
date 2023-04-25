//
//  NFTDetailNameCell.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/21.
//

import UIKit

class NFTDetailNameCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .darkText
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(_ name: String) {
        nameLabel.text = name
        nameLabel.sizeToFit()
    }
}

private extension NFTDetailNameCell {
    func setupUI() {
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28)
        ])
        selectionStyle = .none
    }
}
