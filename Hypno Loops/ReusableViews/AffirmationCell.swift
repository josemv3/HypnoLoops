//
//  AffirmationCell.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 3/1/23.
//

import UIKit

class AffirmationCell: UICollectionViewCell {
    static let reuseidentifier = String(describing: AffirmationCell.self)
    
    @IBOutlet weak var affirmationLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
    }
    
}
