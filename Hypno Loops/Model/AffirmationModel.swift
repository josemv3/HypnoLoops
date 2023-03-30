//
//  AffirmationModel.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 3/30/23.
//

import Foundation

struct AffirmationModel: Decodable {
    var id: String
    var affirmation: String
    var liked = false
}
