//
//  TagCell.swift
//   TUNESDemo
//
//  Created by Nidhi Joshi on 25/04/2021.
//

import UIKit

class TagCell: UICollectionViewCell {

    @IBOutlet weak var tagNameLabel: UILabel?
    var tagItem: String?
    
    func loadData(searchItem: String) {
        tagItem = searchItem
        tagNameLabel?.text = tagItem
    }

}
