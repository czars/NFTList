//
//  NFTListViewModel.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/18.
//

import Foundation
import RxSwift
import RxCocoa

typealias APIEngineNFTViewModelProtocol = APIEngineNFTListProtocol & APIEngineNFTBalanceProtocol

class NFTListViewModel: NFTListViewModelProtocol {
    
    private let bag = DisposeBag()
    private let apiEngine: APIEngineNFTViewModelProtocol
    private let nftsList = BehaviorRelay<[NFTModel]>(value: [])
    private let balanceRelay = BehaviorRelay<Int>(value: 0)
    private let offsetRelay = BehaviorRelay<Int>(value: 0)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let isLoadMoreRelay = BehaviorRelay<Bool>(value: false)
    private let errorSubject = PublishSubject<Error>()
    
    var inputs: NFTListViewModelInputProtocol { self }
    var outputs: NFTListViewModelOutputProtocol { self }
    
    init(apiEngine: APIEngineNFTViewModelProtocol) {
        self.apiEngine = apiEngine
    }
}

extension NFTListViewModel: NFTListViewModelInputProtocol {
    func loadMore() {
        isLoadMoreRelay.accept(true)
        let observable = apiEngine.getNFTList(owner: "0x85fD692D2a075908079261F5E351e7fE0267dB02", offset: offsetRelay.value)
        fetchNFTList(observable: observable)
    }
    
    func refresh() {
        nftsList.accept([])
        isLoadingRelay.accept(true)
        let observable = apiEngine.getNFTList(owner: "0x85fD692D2a075908079261F5E351e7fE0267dB02", offset: 0)
        fetchNFTList(observable: observable)
    }
    
    func getBalance() {
        apiEngine.getNFTBalance(owner: "0x85fD692D2a075908079261F5E351e7fE0267dB02")
            .map { balanceModel -> Int in
                if let result = balanceModel.result {
                    return Int(result.dropFirst(2), radix: 16) ?? 0
                } else {
                    if let balanceError = balanceModel.error {
                        print("[NFTListBalance]: error \(balanceError.code) \(balanceError.message)")
                    }
                    return 0
                }
                
            }.subscribe(onSuccess: { [weak self] balance in
                self?.balanceRelay.accept(balance)
            }, onFailure: { [weak self] error in
                self?.balanceRelay.accept(0)
            })
            .disposed(by: bag)
    }
    
    private func fetchNFTList(observable: Single<NFTListModel>) {
        observable
            .map { [weak self] nftListModel -> [NFTModel] in
                guard let self = self else { return [] }
                guard nftListModel.assets.count != 0 else { return self.nftsList.value }
                return self.nftsList.value + nftListModel.assets
            }
            .subscribe(onSuccess: { [weak self] in
                guard let self = self else { return }
                if self.nftsList.value.count == $0.count { return }
                self.nftsList.accept($0)
                self.offsetRelay.accept($0.count)
            }, onFailure: { [weak self] error in
                self?.errorSubject.onNext(error)
            }, onDisposed: { [weak self] in
                guard let self else { return }
                if self.isLoadingRelay.value == true {
                    self.isLoadingRelay.accept(false)
                }
                if self.isLoadMoreRelay.value == true {
                    self.isLoadMoreRelay.accept(false)
                }
            })
            .disposed(by: bag)
    }
}

extension NFTListViewModel: NFTListViewModelOutputProtocol {
    var isLoading: Driver<Bool> {
        return isLoadingRelay.asDriver()
    }
    
    var isLoadMore: Driver<Bool> {
        return isLoadMoreRelay.asDriver()
    }
    
    var errorMessage: Observable<String> {
        return errorSubject.map {
            $0.localizedDescription
        }.asObservable()
    }
    
    var nfts: Driver<[NFTModel]> {
        return nftsList.asDriver()
    }
    
    var balance: Observable<Int> {
        return balanceRelay.asObservable()
    }
}

