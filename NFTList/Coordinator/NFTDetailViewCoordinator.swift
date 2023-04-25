//
//  NFTDetailViewCoordinator.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/24.
//

import UIKit

class NFTDetailViewCoordinator {
    let rootViewController: UINavigationController
    var dependency: AppDependency!
    var nftModel: NFTModel!
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let viewModel = NFTDatilViewModel(model: nftModel)
        let vc = NFTDetailViewController(viewModel: viewModel)
        rootViewController.pushViewController(vc, animated: true)
    }
}
