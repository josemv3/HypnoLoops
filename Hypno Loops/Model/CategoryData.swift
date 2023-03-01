//
//  CategoryData.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/22/23.
//

//Display one category at a time, keep Likes section. That way I can build each array

import Foundation

struct CategoryData {
    var subCategories: [[CategoryItem]] = []
    var finalCategories: [String: [CategoryItem]] = [:]

    mutating func getSubCategories() {
        for sectionHeader in SectionHeaderData.SectionHeaders.allCases {
            let nestedArray = sectionHeader.categories.map { categoryString -> CategoryItem in
                let categoryName = categoryString.replacingOccurrences(of: "_", with: " ")
                return CategoryItem(origin: sectionHeader.rawValue, name: categoryName)
            }
            subCategories.append(nestedArray)
        }
    }
    
    enum HealthAndHealing: String {
        case Divine_Healing, Gratitude, Self_belief, Intuition, Illness, Self_healing
    }
    enum Love: String {
        case Attracting_love, Self_worth, Marriage, Positive_outlook
    }
    enum Finance: String {
        case Abundance, Wealth, Income, Millionaire_mindset, Confidence, Wealth_attraction, Money_mastery, Prosperity, Deal_making, Financial_stability, Success, Debt_freedom
    }
    enum Mental_Health: String {
        case Healing_from, Depression, Self_acceptance, Inspiration, Strength,
             Self_love, Spirituality, Negative_thoughts
    }
}





//Now we have an array of categoryString, need CatItems
//    var subCategories: [[String]]
//
//    mutating func getSubCategories() {
//        for sectionHeader in SectionHeaderData.SectionHeaders.allCases {
//            let nestedArray = sectionHeader.categories.map { $0.replacingOccurrences(of: "_", with: " ") }
//            subCategories.append(nestedArray)
//        }
//    }
