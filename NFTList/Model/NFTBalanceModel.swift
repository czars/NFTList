//
//  NFTBalanceModel.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/21.
//

import Foundation

struct NFTBalanceModel: Codable, Identifiable {
    let id: String
    let jsonrpc: String
    let result: String?
    let error: NFTBalanceError?
}

struct NFTBalanceError: Codable {
    let code: Int
    let message: String
}
