//
//  URLRequest+NFTBalance.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/20.
//

import Foundation

extension APIRequest {
    static func getEthBalance(owner: String) -> APIRequest {
        
        let bodyDic: [String: Any] = [
            "jsonrpc": "2.0",
            "method": "eth_getBalance",
            "params": [owner, "latest"],
            "id": "1"
        ]
        
        let request = APIRequest(path: "https://rpc.ankr.com/eth_goerli")
        request.method = .post
        request.parameters = bodyDic
        return request
    }
}

