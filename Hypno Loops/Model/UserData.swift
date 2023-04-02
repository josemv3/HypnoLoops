//
//  User.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/11/23.
//

import UIKit

struct UserData {
    var username: String
    var likedAffirmationIds: [String] = []
    
    init(username: String) {
        self.username = username
    }
    
    
    mutating func addLikedAffirmation(affirmationId: String) {
        if !self.likedAffirmationIds.contains(affirmationId) {
            self.likedAffirmationIds.append(affirmationId)
            NetworkManager.shared.updateLikedAffirmations(userAffirmationIDs: self.likedAffirmationIds)
        }
    }
    
    mutating func removeLikedAffirmation(affirmationId: String) {
        let liked = self.likedAffirmationIds.filter { $0 == affirmationId }
        self.likedAffirmationIds = liked
        NetworkManager.shared.updateLikedAffirmations(userAffirmationIDs: self.likedAffirmationIds)
    }
}
