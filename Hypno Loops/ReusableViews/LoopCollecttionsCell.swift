//
//  LoopCollecttionsCell.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/20/23.
//

import UIKit

protocol LoopCellDelegate {
    func didLikeItem(_ item: String)
}

class LoopCollecttionsCell: UICollectionViewCell {
    static let reuseidentifier = String(describing: LoopCollecttionsCell.self)
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var delegate: LoopCellDelegate?
    
//    override func layoutSubviews() {
//        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//    }
    
    var isLiked = false {
           didSet {
               configure()
           }
       }
    
    func configure() {
          if isLiked {
              likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
          } else {
              likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
              //isLiked = false
          }
      }
    
    @IBAction func likeButtonPushed(_ sender: UIButton) {
        isLiked = !isLiked
        //print(cellLabel.text ?? "error")
        //print(isLiked.description)
        delegate?.didLikeItem(cellLabel.text!)
    }
    
}






//Extra in button press:

//        let isLiked = !sender.isSelected
//              configure(isLiked: isLiked)
              //sender.isSelected = isLiked


//        if let buttonImage = likeButton.image(for: .normal) {
//            print("Button image: \(buttonImage)")
//        } else {
//            print("Button has no image assigned.")
//
//        }
