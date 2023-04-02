//
//  AffirmationModel.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 3/30/23.
//

import Foundation
import Firebase

struct AffirmationModel: Decodable, Equatable, Hashable {
    var id: String
    var affirmation: String
    var liked = false
    
    enum CodingKeys: CodingKey {
        case id
        case affirmation
        case liked
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.affirmation = try container.decode(String.self, forKey: .affirmation)
    }
    
    mutating func toggleLiked(userData: inout UserData) {
        self.liked.toggle()
        
        if self.liked {
            userData.addLikedAffirmation(affirmationId: self.id)
        } else {
            userData.removeLikedAffirmation(affirmationId: self.id)
            
        }
        
    }
}
