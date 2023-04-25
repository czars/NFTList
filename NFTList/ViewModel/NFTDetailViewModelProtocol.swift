//
//  NFTDetailViewModelProtocol.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/21.
//

import Foundation
import RxSwift
import RxCocoa

enum DetailViewItemType {
    case image(imageURL: String)
    case name(name: String)
    case descriptionString(desString: String)
}

protocol NFTDetailViewModelInputProtocol {
    func gotoPermalink()
}

protocol NFTDetailViewModelOutputProtocol {
    var detailItems: Driver<[DetailViewItemType]> { get }
    var hasPermalink: Driver<Bool> { get }
    var collectionName: Driver<String> { get }
}

protocol NFTDetailViewModelProtocol {
    var inputs: NFTDetailViewModelInputProtocol { get }
    var outputs: NFTDetailViewModelOutputProtocol { get }
}
