//
//  Helper.swift
//  TUNESDemo
//
//  Created by Nidhi Joshi on 29/04/2021.
//

import Foundation
private let badChars = CharacterSet.alphanumerics.inverted

extension String {
    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }
    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }
    var camelized: String {
        guard !isEmpty else {
            return ""
        }
        let parts = self.components(separatedBy: badChars)
        let first = String(describing: parts.first!).lowercasingFirst
        let rest = parts.dropFirst().map({String($0).uppercasingFirst})
        return ([first] + rest).joined(separator: "")
    }
}
