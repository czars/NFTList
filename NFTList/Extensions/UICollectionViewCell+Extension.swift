//
//  UICollectionViewCell.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/21.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
