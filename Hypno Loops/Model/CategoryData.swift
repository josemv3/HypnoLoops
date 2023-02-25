//
//  CategoryData.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/22/23.
//

//Display one category at a time, keep Likes section. That way I can build each array

import UIKit

struct CategoryData {
    
    let AffirmationPrompts: [CategoryItem] = []
    //dict zip from Section Headers and Categories
    
    enum SectionHeaders: String, CaseIterable {
        case Health_and_Healing, Love, Finance,
             Mental_Health, Self_Grounding, Entrepreneur,
             Sports_Competitive, Weight_Loss
        
        
        
        var categories: [String] {
            switch self {
            case .Health_and_Healing:
                return ["Divine Healing", "Gratitude", "Self-belief", "Intuition", "Illness", "Self-healing"]
            default:
                return [""]
            }
        }
    }
    
    enum categories2: String {
        case Divine_Healing, Gratitude, Self_belief, Intuition, Illness, Self_healing
    }
    
    let affirmations: [categories2: [String]] = [.Divine_Healing: ["I receive Gods healing into my cells", "The power of Gods love heals me", "The Fountain of Gods love healed me", "The Power of God has healed me", "I am intuitively guided to my healing", "I knew I was healed like God promised", "I am divinely guided to my healing"]
    ]
    
    var item: CategoryItem = CategoryItem(origin: SectionHeaders.Health_and_Healing.rawValue, name: "Divine Healing", affirmation:  ["I receive Gods healing into my cells", "The power of Gods love heals me", "The Fountain of Gods love healed me", "The Power of God has healed me", "I am intuitively guided to my healing", "I knew I was healed like God promised", "I am divinely guided to my healing"])
}
