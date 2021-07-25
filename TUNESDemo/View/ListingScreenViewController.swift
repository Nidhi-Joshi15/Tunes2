//
//  ListingScreenViewController.swift
//  TUNESDemo
//
//  Created by Nidhi Joshi on 28/04/2021.
//

import Foundation
import UIKit

class ListingScreenViewController: UIViewController {
    @IBOutlet weak var listGridsegment: UISegmentedControl?
    @IBOutlet weak var gridView: UICollectionView?

    var coordinator: ListingScreenCoordinator?
    var viewModel: ListingScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = ListingScreenCoordinator(navigationController: self.navigationController ?? UINavigationController())
        gridView?.registerNib(Constant.headerView)
        gridView?.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.headerView)
        gridView?.registerNib(Constant.mediaCellIdentifier)
        
        gridView?.registerNib(Constant.mediaSingleCellIdentifier)
        viewModel?.fetchData()
        viewModel?.didLoad = {
            self.reloadData()
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        if viewModel?.displayView == DisplayView.grid {
            viewModel?.displayView = .list
        } else {
            viewModel?.displayView = .grid
        }
        reloadData()
    }
    
    func reloadData() {
        switch self.viewModel?.displayView {
        case .grid:
            self.gridView?.reloadData()
        case .list:
            self.gridView?.reloadData()
        default:
            break
        }
    }
    
}

extension ListingScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getItemCount(section) ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.getsectionCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch viewModel?.displayView {
        case .grid:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constant.mediaCellIdentifier, for: indexPath) as? MediaCell
            cell?.loadData(media: viewModel?.getItemAt(indexPath.section, indexPath.row))
                    // Configure the cell
            return cell ?? UICollectionViewCell()
            
        case .list:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constant.mediaSingleCellIdentifier, for: indexPath) as? MediaSingleCell
            cell?.loadData(media: viewModel?.getItemAt(indexPath.section, indexPath.row))
                    // Configure the cell
            return cell ?? UICollectionViewCell()
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.didSelectMedia(viewModel?.getItemAt(indexPath.section, indexPath.row))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = viewModel?.displayView == .grid ? 3 : 1

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {return CGSize.zero }

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: viewModel?.displayView == .grid ? 210 : 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView ?? HeaderView()
                headerView.titleLabel.text = viewModel?.getSectionAt(indexPath.section)?.sectionName ?? ""
                return headerView

            default:
                return UICollectionReusableView()
            }
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 45)
        }
}
