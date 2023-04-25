//
//  URLRequest+NFTList.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/19.
//

import Foundation
import Alamofire

class APIRequest {
    let path: String
    var method: HTTPMethod
    var parameters: [String: Any]?
    
    init(path: String, method: HTTPMethod = .get) {
        self.path = path
        self.method = method
    }
}

extension APIRequest {
    static func getNFTListRequest(owner: String, offset: Int) -> APIRequest {
        let query = [
            "owner": owner,
            "offset": String(offset),
            "order_direction": "asc"
        ]

        let request = APIRequest(path: "https://testnets-api.opensea.io/api/v1/assets/")
        request.parameters = query
        return request
    }
}
