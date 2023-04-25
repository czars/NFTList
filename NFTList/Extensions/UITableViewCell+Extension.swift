//
//  UITableViewCell+Extension.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/21.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
