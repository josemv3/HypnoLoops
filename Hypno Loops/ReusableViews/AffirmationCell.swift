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
    var userData: UserData!
    static let reuseidentifier = String(describing: AffirmationCell.self)
    
    @IBOutlet weak var affirmationLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        print("pressed")
        
        if affirmation.liked {
            let image = UIImage(systemName: "heart.fill")
            DispatchQueue.main.async {
                self.likeButton.setImage(image, for: .normal)
            }
        } else {
            let image = UIImage(systemName: "heart")
            DispatchQueue.main.async {
                self.likeButton.setImage(image, for: .normal)
            }
        }
        
        affirmation.toggleLiked(userData: &userData)
    }
    

    
}
