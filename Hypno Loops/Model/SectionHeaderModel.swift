//
//  SectionHeaderModel.swift
//  Hypno Loops
//
//  Created by Olijujuan Green on 4/1/23.
//

import Foundation

struct SectionHeaderModel: Decodable, Hashable {
    var headerTitle: String
    var categories: [CategoryModel]
}
