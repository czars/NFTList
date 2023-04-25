//
//  NFTListViewController.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/17.
//

import UIKit
import RxSwift
import RxCocoa

protocol NFTListViewControllerDelegate: NSObject {
    func didSelect(nft: NFTModel, with: NFTListViewController)
}

class NFTListViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let width = (UIScreen.main.bounds.width / 2) - 10
        let height = width * 1.3
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.itemSize = CGSize(width: width, height: height)
        flowlayout.minimumInteritemSpacing = 10
        flowlayout.minimumLineSpacing = 10
        flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        return collectionView
    }()
    
    private let refreshControl = UIRefreshControl()
    private let viewModel: NFTListViewModelProtocol
    private let bag = DisposeBag()
    weak var delegate: NFTListViewControllerDelegate?

    init(viewModel: NFTListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        binds()
        refresh()
        viewModel.inputs.getBalance()
    }
}

private extension NFTListViewController {
    func setupCollectionView() {
        title = "NFT List"
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        collectionView.refreshControl = refreshControl
        // TODO: use custom cell
        collectionView.register(NFTListItemCell.self, forCellWithReuseIdentifier: NFTListItemCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func binds() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
        outputs.balance
            .map{ "ETH: \(Double($0)/1e18)" }
            .asObservable()
            .bind(to: self.rx.title)
            .disposed(by: bag)
        
        outputs.nfts
            .drive(collectionView.rx.items) { (collectionView, row, nftModel) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTListItemCell.reuseIdentifier, for: indexPath) as! NFTListItemCell
                cell.setupModel(model: nftModel)
                return cell
            }
            .disposed(by: bag)
        
        outputs.errorMessage
            .subscribe(onNext: { errorMessage in
                print("[NFTList]: error \(errorMessage)")
            })
            .disposed(by: bag)
        
        outputs.isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: bag)
        
        outputs.isLoadMore
            .drive(collectionView.rx.isLoadingMore)
            .disposed(by: bag)
        
        // UI interactive
        collectionView.rx.reachedBottom(withOffset: -44)
            .debounce(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
            .filter { $0 }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { _ in
                inputs.loadMore()
            })
            .disposed(by: bag)
        
        collectionView.rx.modelSelected(NFTModel.self)
            .subscribe(onNext: { [weak self] nft in
                guard let self = self else { return }
                self.delegate?.didSelect(nft: nft, with: self)
            })
            .disposed(by: bag)
        
        refreshControl.rx.controlEvent(.valueChanged).asObservable()
            .subscribe(onNext: {
                inputs.refresh()
            })
            .disposed(by: bag)
        
        
    }
    
    func refresh() {
        viewModel.inputs.refresh()
    }
}

