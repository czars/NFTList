//
//  NFTDetailViewController.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/20.
//

import Foundation
import RxSwift
import RxCocoa

class NFTDetailViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.bounces = false
        return tableView
    }()
    
    private lazy var permalinkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitleColor(.darkText, for: .normal)
        return button
    }()
    
    private let buttonContainer = UIView()
    private let bag = DisposeBag()
    private let viewModel: NFTDetailViewModelProtocol
    
    init(viewModel: NFTDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupUI()
        binds()
    }
}

private extension NFTDetailViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(buttonContainer)
        buttonContainer.addSubview(permalinkButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        permalinkButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: buttonContainer.topAnchor),
            
            buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            permalinkButton.heightAnchor.constraint(equalToConstant: 44),
            permalinkButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 28),
            permalinkButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -28),
            permalinkButton.bottomAnchor.constraint(equalTo: buttonContainer.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            permalinkButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 12)
        ])
        
        permalinkButton.setTitle("Go To Assets Page", for: .normal)
        
        tableView.register(NFTDetailImageCell.self, forCellReuseIdentifier: NFTDetailImageCell.reuseIdentifier)
        tableView.register(NFTDetailNameCell.self, forCellReuseIdentifier: NFTDetailNameCell.reuseIdentifier)
        tableView.register(NFTDetailDescriptionCell.self, forCellReuseIdentifier: NFTDetailDescriptionCell.reuseIdentifier)
    }
    
    func binds() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
        outputs.detailItems
            .drive(tableView.rx.items) { (tableView, index, item) in
                switch item {
                case .image(imageURL: let imageURL):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTDetailImageCell.reuseIdentifier, for: IndexPath(row: index, section: 0)) as? NFTDetailImageCell else { return UITableViewCell() }
                    cell.setupData(imageURL)
                    return cell
                case .name(name: let name):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTDetailNameCell.reuseIdentifier, for: IndexPath(row: index, section: 0)) as? NFTDetailNameCell else { return UITableViewCell() }
                    cell.setupData(name)
                    return cell
                case .descriptionString(desString: let description):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTDetailDescriptionCell.reuseIdentifier, for: IndexPath(row: index, section: 0)) as? NFTDetailDescriptionCell else { return UITableViewCell() }
                    cell.setupData(description)
                    return cell
                }
            }
            .disposed(by: bag)
        
        outputs.hasPermalink
            .map{ !$0 }
            .drive(buttonContainer.rx.isHidden)
            .disposed(by: bag)
        
        outputs.collectionName
            .drive(self.rx.title)
            .disposed(by: bag)
        
        permalinkButton.rx.tap
            .subscribe { _ in
                inputs.gotoPermalink()
            }
            .disposed(by: bag)
    }
}
