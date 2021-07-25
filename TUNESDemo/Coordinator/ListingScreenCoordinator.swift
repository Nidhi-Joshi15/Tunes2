//
//  ListingScreenCoordinator.swift
//  TUNESDemo
//
//  Created by Nidhi Joshi on 29/04/2021.
//

import Foundation
import UIKit

class ListingScreenCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension ListingScreenCoordinator: ListingScreenViewControllerDelegate {
    func didSelectMedia(_ media: Media?) {
        let viewController = DetailViewController.create(of: .main)
        let viewModel = DetailScreenViewModel(media: media)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}

protocol ListingScreenViewControllerDelegate: class {
    func didSelectMedia(_ media: Media?)
}
