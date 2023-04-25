//
//  AppCoordinator.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/24.
//

import UIKit

class AppCoordinator: NSObject {
    
    var rootViewController: UINavigationController
    let dependency = AppDependency()
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let viewModel = NFTListViewModel(apiEngine: dependency.apiEngine)
        let vc = NFTListViewController(viewModel: viewModel)
        vc.delegate = self
        rootViewController = UINavigationController(rootViewController: vc)
    }
    
}

extension AppCoordinator: NFTListViewControllerDelegate {
    func didSelect(nft: NFTModel, with: NFTListViewController) {
        let detailCoordinator = NFTDetailViewCoordinator(rootViewController: rootViewController)
        detailCoordinator.dependency = dependency
        detailCoordinator.nftModel = nft
        detailCoordinator.start()
    }
}
