//
//  SVGProcessor.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/23.
//

import Foundation
import Kingfisher
import SVGKit

public struct SVGImgProcessor: ImageProcessor {
    public var identifier: String = "com.appidentifier.svgprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
            let imsvg = SVGKImage(data: data)
            return imsvg?.uiImage
        }
    }
}
