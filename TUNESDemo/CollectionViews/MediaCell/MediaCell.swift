//
//  MediaCell.swift
//   TUNESDemo
//
//  Created by Nidhi Joshi on 26/04/2021.
//

import UIKit
import SDWebImage

class MediaCell: UICollectionViewCell {
    @IBOutlet weak var mediaImage: UIImageView?
    @IBOutlet weak var mediaTitle: UILabel?

    var media: Media?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadData(media: Media?) {
        mediaTitle?.text = media?.trackCensoredName
        mediaImage?.sd_setImage(with: URL(string: (media?.artworkUrl100)  ?? ""), placeholderImage: UIImage(named: "placeholderImage"))
    }
    
}
