//
//  APIEngine+NFTList.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/19.
//

import Foundation
import RxSwift

protocol APIEngineNFTListProtocol {
    func getNFTList(owner: String, offset: Int) -> Single<NFTListModel>
}

extension APIEngine: APIEngineNFTListProtocol {
    func getNFTList(owner: String, offset: Int) -> Single<NFTListModel> {
        let request = APIRequest.getNFTListRequest(owner: owner, offset: offset)
        return sendingRequest(request: request).asSingle()
    }
}
