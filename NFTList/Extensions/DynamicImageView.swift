//
//  DynamicImageView.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/22.
//

import UIKit

class DynamicImageView: UIImageView {
    
    var fixedWidth: CGFloat
    
    init(fixedWidth: CGFloat) {
        self.fixedWidth = fixedWidth
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        guard var size = image?.size else { return CGSize.zero }
        size.width = fixedWidth
        if let image = self.image {
            let ratio = fixedWidth / image.size.width
            size.height = image.size.height * ratio
        }
        return size
    }

}
