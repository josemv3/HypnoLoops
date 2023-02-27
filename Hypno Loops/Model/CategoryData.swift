//
//  CategoryData.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/22/23.
//

//Display one category at a time, keep Likes section. That way I can build each array

import Foundation

struct CategoryData {
    
//    let sectionHeader = SectionHeaderData()
//    let test = sectionHeader.nestedStringArrays
    //let AffirmationPrompts: [String] = []
    //dict zip from Section Headers and Categories
    

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
    
    //Sports_Competitive, Weight_Loss
    
    //remove
    var item: CategoryItem = CategoryItem(origin: SectionHeaderData.SectionHeaders.Health_and_Healing.rawValue, name: SectionHeaderData.SectionHeaders.Health_and_Healing.categories[0].replacingOccurrences(of: "_", with: " "))
}
