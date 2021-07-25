//
//  MediaItemProtocol.swift
//   TUNESDemo
//
//  Created by Nidhi Joshi on 26/04/2021.
//

import Foundation
protocol MediaItemsProtocol {
    init(sectionList: [Section])
    var sections: [Section] {get set}
}

struct Section {
    var sectionName: String
    var media: [Media]
}

class MediaItems: MediaItemsProtocol {
    var sections: [Section]
    required init(sectionList: [Section]) {
        sections = sectionList
    }

}
