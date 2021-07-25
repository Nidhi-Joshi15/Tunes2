//
//  SearchScreenCoordinator.swift
//  TUNESDemo
//
//  Created by Nidhi Joshi on 28/04/2021.
//

import Foundation
import UIKit

class SearchScreenCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension SearchScreenCoordinator: SearchScreenViewControllerDelegate {
    func didSubmitMedia(_ url: String) {
        let vc = ListingScreenViewController.create(of: .main)
        let viewModel = ListingScreenViewModel(url)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchMediaTag(_ viewModel: SearchScreenViewModel) {
        let viewController = MediaListViewController.create(of: .main)
        let viewModelMedialist = MediaListViewModel(selsectedType: viewModel.selectedList ?? [String]())
        viewController.viewModel = viewModelMedialist
        viewController.delegate = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}

protocol SearchScreenViewControllerDelegate: class {
    func didSubmitMedia(_ url: String)
    func fetchMediaTag(_ viewModel: SearchScreenViewModel)
}
