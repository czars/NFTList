//
//  NFTDetailViewModel.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/21.
//

import Foundation
import RxSwift
import RxCocoa

class NFTDatilViewModel: NFTDetailViewModelProtocol {
    
    private let model: NFTModel
    private let bag = DisposeBag()
    private let detailItemsRelay = BehaviorRelay<[DetailViewItemType]>(value: [])
    
    
    var inputs: NFTDetailViewModelInputProtocol { self }
    var outputs: NFTDetailViewModelOutputProtocol { self }
    
    init(model: NFTModel) {
        self.model = model
        convertToDetailItems(model)
    }
}

extension NFTDatilViewModel: NFTDetailViewModelInputProtocol {
    func gotoPermalink() {
        guard let url = URL(string: model.permalink) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension NFTDatilViewModel: NFTDetailViewModelOutputProtocol {
    var detailItems: Driver<[DetailViewItemType]> {
        return detailItemsRelay.asDriver()
    }
    
    var hasPermalink: Driver<Bool> {
        var canOpenURL = false
        if let url = URL(string: model.permalink) {
            canOpenURL = UIApplication.shared.canOpenURL(url)
        }
        return BehaviorRelay<Bool>(value: canOpenURL).asDriver()
    }
    
    var collectionName: Driver<String> {
        return BehaviorRelay<String>(value: model.collection.name).asDriver()
    }
}

private extension NFTDatilViewModel {
    func convertToDetailItems(_ model: NFTModel) {
        var detailItems = [DetailViewItemType]()
        
        detailItems.append(.image(imageURL: model.image_url ?? ""))
        detailItems.append(.name(name: model.name ?? ""))
        detailItems.append(.descriptionString(desString: model.description ?? "No description"))
        
        detailItemsRelay.accept(detailItems)
    }
}


