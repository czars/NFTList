//
//  NFTDetailImageCell.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/21.
//

import UIKit
import Kingfisher

class NFTDetailImageCell: UITableViewCell {
    
    private lazy var assetImageView: DynamicImageView = {
        let imageView = DynamicImageView(fixedWidth: self.bounds.size.width)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(_ imageURL: String) {
        
        if imageURL.hasSuffix("svg") {
            assetImageView.kf.setImage(
                with: URL(string: imageURL),
                placeholder: UIImage(named: "Placeholder_view_vector"),
                options: [.processor(SVGImgProcessor())]
            )
        } else {
            assetImageView.kf.setImage(
                with: URL(string: imageURL),
                placeholder: UIImage(named: "Placeholder_view_vector")
            )
        }
        
        
    }
}

private extension NFTDetailImageCell {
    func setupUI() {
        contentView.addSubview(assetImageView)
        assetImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            assetImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            assetImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            assetImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
        selectionStyle = .none
    }
}
