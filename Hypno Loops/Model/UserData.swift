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
    
    init(username: String, likedAffirmationIds: [String]) {
        self.username = username
        self.likedAffirmationIds = likedAffirmationIds
    }
    
    
    mutating func addLikedAffirmation(affirmationId: String) {
        if !self.likedAffirmationIds.contains(affirmationId) {
            //NetworkManager.userData!.likedAffirmationIds.append(affirmationId)
            self.likedAffirmationIds.append(affirmationId)
            NetworkManager.shared.updateLikedAffirmations(likedAffirmationIds: self.likedAffirmationIds)
        }
    }
    
    mutating func removeLikedAffirmation(affirmationId: String) {
        let liked = self.likedAffirmationIds.filter { $0 != affirmationId }
        print("LIKED IDS", liked)
        self.likedAffirmationIds = liked
        NetworkManager.shared.updateLikedAffirmations(likedAffirmationIds: self.likedAffirmationIds)
    }
}
