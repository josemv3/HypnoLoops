//
//  Categories.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 3/30/23.
//

import Foundation

struct CategoryModel: Decodable {
    var title: String
    var affirmations: [AffirmationModel]
}
