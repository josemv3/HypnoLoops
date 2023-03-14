//
//  LoopCollectionViewSectionHeader.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/6/23.
//

import UIKit

class CategoryViewHeader: UICollectionReusableView {
    var label = UILabel()
    
    override func layoutSubviews() {
      label.translatesAutoresizingMaskIntoConstraints = false
      addSubview(label)
      
      NSLayoutConstraint.activate([
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        
     
      ])
    }
}
