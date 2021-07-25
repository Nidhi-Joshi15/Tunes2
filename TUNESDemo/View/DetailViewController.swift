//
//  DetailViewController.swift
//  TUNESDemo
//
//  Created by Nidhi Joshi on 29/04/2021.
//

import Foundation
import UIKit
import AVKit
import SDWebImage

class DetailViewController: UIViewController, AVPlayerViewControllerDelegate {
    
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var lblDetail: UILabel?
    @IBOutlet weak var lblAmount: UILabel?
    
    @IBOutlet weak var imageViewMedia: UIImageView?
    var player: AVPlayer?
    var viewModel: DetailScreenViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    func setupData() {
        lblTitle?.text = "Name : " + (viewModel?.mediaItem?.trackCensoredName ?? "")
        lblTitle?.sizeToFit()
        lblDetail?.text = "Collection Name : " + (viewModel?.mediaItem?.collectionCensoredName ?? "")
        lblDetail?.sizeToFit()
        lblAmount?.text = "Artist : " + (viewModel?.mediaItem?.artistName ?? "")
        lblAmount?.sizeToFit()
        imageViewMedia?.sd_setImage(with: URL(string: (viewModel?.mediaItem?.artworkUrl100)  ?? ""), placeholderImage: UIImage(named: "placeholderImage"))
    }

    @IBAction func playVideoClicked(_ sender: Any) {
        setupVideo()
    }
    
    func setupVideo() {
        guard let url = URL(string: viewModel?.mediaItem?.previewUrl ?? "") else {
            print("Umm, looks like an invalid URL!")
            return
        }

        player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.delegate = self
        controller.player = player

        // present the player controller & play
        present(controller, animated: true) {
            self.player?.play()
        }
    }
}
