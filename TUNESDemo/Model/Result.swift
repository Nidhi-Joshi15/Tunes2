//
//  Result.swift
//   TUNESDemo
//
//  Created by Nidhi Joshi on 26/04/2021.
//

import Foundation
class Result: Codable {
    var resultCount: Int?
    var results: [Media]?
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try values.decodeIfPresent(Int.self, forKey: .resultCount)
        results = try values.decodeIfPresent([Media].self, forKey: .results)
    }
    
    func convertMedia() -> MediaItemsProtocol {
        var sections = [Section]()
        for item in Constant.mediaTypeList {
            if let list = results?.filter({$0.kind == item}), !list.isEmpty {
                sections.append(Section(sectionName: item, media: list))
            }
        }
        return MediaItems(sectionList: sections)
    }
}
