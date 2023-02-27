//
//  SectionHeaderData.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/25/23.
//

import Foundation

struct SectionHeaderData {
    
    var sectionHeaders: [String] = [String]()
    
    mutating func makeSectionHeaders() {
        sectionHeaders = SectionHeaders.allCases.map { $0.rawValue }
    }
    
    enum SectionHeaders: String, CaseIterable {
        case Health_and_Healing, Love, Finance,
             Mental_Health, Self_Grounding, Entrepreneur,
             Sports_Competitive, Weight_Loss
        
        
        var categories: [String] {
            switch self {
            case .Health_and_Healing:
                return [
                    CategoryData.HealthAndHealing.Divine_Healing.rawValue,
                    CategoryData.HealthAndHealing.Gratitude.rawValue,
                    CategoryData.HealthAndHealing.Self_belief.rawValue,
                    CategoryData.HealthAndHealing.Intuition.rawValue,
                    CategoryData.HealthAndHealing.Illness.rawValue,
                    CategoryData.HealthAndHealing.Self_healing.rawValue
                ]
            case .Love:
                return [
                    CategoryData.Love.Attracting_love.rawValue,
                    CategoryData.Love.Self_worth.rawValue,
                    CategoryData.Love.Marriage.rawValue,
                    CategoryData.Love.Positive_outlook.rawValue
                ]
            case .Finance:
                return [
                    CategoryData.Finance.Abundance.rawValue,
                    CategoryData.Finance.Wealth.rawValue,
                    CategoryData.Finance.Income.rawValue,
                    CategoryData.Finance.Millionaire_mindset.rawValue,
                    CategoryData.Finance.Wealth_attraction.rawValue,
                    CategoryData.Finance.Money_mastery.rawValue,
                    CategoryData.Finance.Prosperity.rawValue,
                    CategoryData.Finance.Deal_making.rawValue,
                    CategoryData.Finance.Financial_stability.rawValue,
                    CategoryData.Finance.Success.rawValue,
                    CategoryData.Finance.Debt_freedom.rawValue
                ]
            default:
                return [""]
            }
        }
    }
    //Makes subcategores - Cell Items:
    var nestedStringArrays: [[String]] {
        var nestedStringArrays = [[String]]()
        
        for sectionHeader in SectionHeaders.allCases {
            let nestedArray = sectionHeader.categories.map { $0.replacingOccurrences(of: "_", with: " ") }
            nestedStringArrays.append(nestedArray)
        }
        return nestedStringArrays
    }

}
