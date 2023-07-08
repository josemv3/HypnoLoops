//
//  CornerRadiusModifiers.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/6/23.
//

import Foundation

enum CornerRadiusModifiers: CGFloat {
    case small, normal, large
    
    var size: CGFloat {
        switch(self) {
        case .small:
            return 2
        case .normal:
            return 5
        case .large:
            return 15
        }
    }
}
