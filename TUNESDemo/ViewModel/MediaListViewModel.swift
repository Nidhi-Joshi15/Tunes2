//
//  MediaListViewModel.swift
//  TUNESDemo
//
//  Created by Nidhi Joshi on 27/04/2021.
//

import Foundation
class MediaListViewModel {
    var mediaTypeList: [String]
    var selectedType: [String]
    
    init(selsectedType: [String]) {
        mediaTypeList =  ["Album", "Artish", "Book", "Movie", "Music Video", "Podcast", "Song"]
        selectedType = selsectedType
    }
    func getList() -> [String]? {
        return mediaTypeList
    }
    func getListCount() -> Int {
        return mediaTypeList.count
    }
    func getItemAt(_ index: Int) -> String {
        return mediaTypeList[index]
    }
    
    func hasMediaType() -> Bool {
        return !mediaTypeList.isEmpty
    }
    
}
