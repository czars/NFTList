//
//  NFTListViewModelProtocol.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/18.
//

import Foundation
import RxCocoa
import RxSwift

enum NFTListViewState: Equatable {
    static func == (lhs: NFTListViewState, rhs: NFTListViewState) -> Bool {
        switch (lhs, rhs) {
        case (.isLoading, .isLoading),
            (.isLoadMore, .isLoadMore),
            (.loadFinished, .loadFinished):
            return true
        case let (.error(l), .error(r)):
            return l.localizedDescription == r.localizedDescription
        default:
            return false
        }
    }
    
    case isLoading
    case isLoadMore
    case error(Error)
    case loadFinished(isLoadMore: Bool)
}

protocol NFTListViewModelInputProtocol {
    func loadMore()
    func refresh()
    func getBalance()
}

protocol NFTListViewModelOutputProtocol {
    var nfts: Driver<[NFTModel]> { get }
    var balance: Observable<Int> { get }
    var isLoading: Driver<Bool> { get }
    var isLoadMore: Driver<Bool> { get }
    var errorMessage: Observable<String> { get }
}

protocol NFTListViewModelProtocol {
    var inputs: NFTListViewModelInputProtocol { get }
    var outputs: NFTListViewModelOutputProtocol { get }
}


