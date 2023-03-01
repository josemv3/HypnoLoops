//
//  CategoryItem.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/14/23.
//

import Foundation

struct CategoryItem: Hashable {
    let origin: String //Enum type
    let name: String
    var liked: Bool = false
}
