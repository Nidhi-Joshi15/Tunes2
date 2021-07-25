//
//  ListingScreenViewModel.swift
//  TUNESDemo
//
//  Created by Nidhi Joshi on 28/04/2021.
//

import Foundation
import UIKit

enum DisplayView {
    case grid
    case list
}
class ListingScreenViewModel: ListingScreenViewModelProtocol {
    
    func getList(_ section: Int) -> [Media]? {
        return mediaList?.sections[section].media
    }
    
    func getSectionList() -> [Section] {
        return mediaList?.sections ?? []
    }
    
    func getItemAt(_ section: Int, _ index: Int) -> Media? {
        return mediaList?.sections[section].media[index]
    }
    
    func getSectionAt(_ index: Int) -> Section? {
        return mediaList?.sections[index]
    }
    
    func getsectionCount() -> Int {
        return mediaList?.sections.count ?? 0
    }
    
    func getItemCount(_ section: Int) -> Int {
        return mediaList?.sections[section].media.count ?? 0
    }
    
    var mediaList: MediaItemsProtocol?
    var didLoad: (() -> Void)?
    var failToLoad: ((String?) -> Void)?
    var serviceManager: ServiceManager?
    var serviceURL: String
    var displayView: DisplayView? = .grid
    init(_ url: String) {
        serviceURL = url
        serviceManager = ServiceManager()
    }
    
    func fetchData() {
        serviceManager?.fetchData(url: serviceURL, onSuccess: { [weak self] results in
            self?.mediaList = results?.convertMedia()
            self?.didLoad?()
        }) { [weak self] errorMessage in
            self?.failToLoad?(errorMessage)
        }
    }
    
}

protocol ListingScreenViewModelProtocol {
    var didLoad: (() -> Void)? {get set}
    var failToLoad: ((String?) -> Void)? {get set}
    var mediaList: MediaItemsProtocol? {get set}
    var displayView: DisplayView? {get set}
    
    func getList(_ section: Int) -> [Media]?
    func getSectionList() -> [Section]
    func getItemAt(_ section: Int, _ index: Int) -> Media?
    func getSectionAt(_ index: Int) -> Section?
    func getsectionCount() -> Int
    func getItemCount(_ section: Int) -> Int
    func fetchData()
    
}
