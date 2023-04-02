//
//  AffirmationCell.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 3/1/23.
//

import UIKit
import Firebase

class AffirmationCell: UICollectionViewCell {
    var affirmation: AffirmationModel!
    static let reuseidentifier = String(describing: AffirmationCell.self)
    
    @IBOutlet weak var affirmationLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        affirmation.toggleLiked(userData: &NetworkManager.userData!)
        
        if affirmation.liked {
            let image = UIImage(systemName: "heart.fill")
            self.likeButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "heart")
            self.likeButton.setImage(image, for: .normal)
        }
    }
    
    func setLiked() {
        if NetworkManager.userData!.likedAffirmationIds.contains(affirmation.id) {
            affirmation.liked = true
        }
    }
    
}
