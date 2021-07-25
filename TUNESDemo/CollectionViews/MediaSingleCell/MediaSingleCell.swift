//
//  MediaSingleCell.swift
//  TUNESDemo
//
//  Created by Nidhi Joshi on 28/04/2021.
//

import UIKit
import SDWebImage

class MediaSingleCell: UICollectionViewCell {

    @IBOutlet weak var mediaDetail: UILabel?
    @IBOutlet weak var mediaTitle: UILabel?
    @IBOutlet weak var mediaImageView: UIImageView?
    
    var mediaItem: Media?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadData(media: Media?) {
        mediaItem = media
        mediaTitle?.text = media?.collectionCensoredName
        mediaDetail?.text = media?.trackCensoredName
        mediaImageView?.sd_setImage(with: URL(string: (media?.artworkUrl100)  ?? ""), placeholderImage: UIImage(named: "placeholderImage"))
    }

}
