//
//  NFTDetailDescriptionCell.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/21.
//

import UIKit

class NFTDetailDescriptionCell: UITableViewCell {
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .black
        textView.isUserInteractionEnabled = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(_ description: String) {
        textView.text = description
        textView.sizeThatFits(textView.contentSize)
    }
}

private extension NFTDetailDescriptionCell {
    func setupUI() {
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setContentCompressionResistancePriority(.required, for: .vertical)

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        selectionStyle = .none
    }
}


