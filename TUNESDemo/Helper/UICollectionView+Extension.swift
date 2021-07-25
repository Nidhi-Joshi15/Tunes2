//
//  UICollectionView+Extension.swift
//  TUNESDemo
//
//  Created by Nidhi Joshi on 28/04/2021.
//

import Foundation
import UIKit

extension UICollectionView {
    func registerNib(_ nibName: String, bundle: Bundle? = nil) {
        register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier: nibName)
    }
}
