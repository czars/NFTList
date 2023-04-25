//
//  NFTListViewModelTests.swift
//  NFTListTests
//
//  Created by Paul.Chou on 2023/4/24.
//

import XCTest
@testable import NFTList
import RxSwift
import RxCocoa
import RxTest

class NFTListViewModelTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var bag: DisposeBag!
    
    override func setUpWithError() throws {
        self.scheduler = TestScheduler(initialClock: 0)
        self.bag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        self.scheduler = nil
        self.bag = nil
    }
    
    func testViewModelIsLoading() {
        
        let isLoading = scheduler.createObserver(Bool.self)
        let viewModel = NFTListViewModel(apiEngine: MockAPIEngine())
        
        viewModel.outputs.isLoading
            .drive(isLoading)
            .disposed(by: bag)
        
        scheduler.createColdObservable([.next(10, ()), .next(30, ())])
            .bind(onNext: { _ in
                viewModel.inputs.refresh()
            })
            .disposed(by: bag)
        
        scheduler.start()
        
        XCTAssertEqual(isLoading.events, [.next(0, false), .next(10, true), .next(30, true)])
    }
    
    func testViewModelIsLoadMore() {
        let isLoading = scheduler.createObserver(Bool.self)
        
        let viewModel = NFTListViewModel(apiEngine: MockAPIEngine())
        
        viewModel.outputs.isLoadMore
            .drive(isLoading)
            .disposed(by: bag)
        
        scheduler.createColdObservable([.next(10, ()), .next(30, ())])
            .bind(onNext: { _ in
                viewModel.inputs.loadMore()
            })
            .disposed(by: bag)
        
        scheduler.start()
        
        XCTAssertEqual(isLoading.events, [.next(0, false), .next(10, true), .next(30, true)])
    }
    
    func testFetchItems() {
        let viewModel = NFTListViewModel(apiEngine: MockAPIEngine())
        let expectedItems = [NFTModel].init(repeating: NFTModel.defaultModel(), count: 5)
        
        viewModel.outputs.nfts
            .skip(2)
            .drive(onNext: { list in
                XCTAssertEqual(list, expectedItems)
            })
            .disposed(by: bag)
        
        viewModel.inputs.refresh()
    }
}

class MockAPIEngine: APIEngineNFTViewModelProtocol {
    func getNFTList(owner: String, offset: Int) -> Single<NFTListModel> {
        let mockModel = NFTListModel(assets: [NFTModel].init(repeating: NFTModel.defaultModel(), count: 5))
        return Observable.just(mockModel)
            .delay(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
            .asSingle()
        
    }
    
    func getNFTBalance(owner: String) -> Single<NFTBalanceModel> {
        let mockModel = NFTBalanceModel(id: "1", jsonrpc: "2.0", result: "0x543210", error: nil)
        return Observable.just(mockModel)
            .delay(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
            .asSingle()
        
    }
}
