//
//  NFTModel.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/18.
//

import Foundation

struct NFTModel: Identifiable, Equatable, Codable, Hashable {
    let id: Int
    let image_url: String?
    let name: String?
    let collection: NFTCollection
    let description: String?
    let permalink: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(permalink)
    }
    
    static func defaultModel() -> NFTModel {
        return NFTModel(
            id: 0,
            image_url: "",
            name: "",
            collection: NFTCollection(name: ""),
            description: "",
            permalink: ""
        )
    }
}

struct NFTCollection: Equatable, Codable {
    let name: String
}

struct NFTListModel: Equatable, Codable {
    let assets: [NFTModel]
}
