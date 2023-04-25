//
//  APIEngine+NFTBalance.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/21.
//

import Foundation
import RxSwift

protocol APIEngineNFTBalanceProtocol {
    func getNFTBalance(owner: String) -> Single<NFTBalanceModel>
}

extension APIEngine: APIEngineNFTBalanceProtocol {
    func getNFTBalance(owner: String) -> Single<NFTBalanceModel> {
        let request = APIRequest.getEthBalance(owner: owner)
        return sendingRequest(request: request).asSingle()
    }
}
