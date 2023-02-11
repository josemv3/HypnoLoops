//
//  CornerRadiusSize.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/11/23.
//

import Foundation

enum CornerRadiusSize: CGFloat {
    case small, normal, large
    
    var size: CGFloat {
        switch(self) {
        case .small:
            return 2
        case .normal:
            return 4
        case .large:
            return 6
        }
    }
}
