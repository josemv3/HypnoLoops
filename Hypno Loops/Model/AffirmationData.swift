//
//  Affirmations.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/25/23.
//

import Foundation


struct AffirmationData {

    
//    enum categories2: String {
//        case Divine_Healing, Gratitude, Self_belief, Intuition, Illness, Self_healing
//    }
    
    
    //Use category item name (made from enum?) to grab Affirmations

    //  Make these computed, only need 1 at a time
    
    let affirmationsHealing: [CategoryData.HealthAndHealing: [String]] = [
        .Divine_Healing: ["I receive Gods healing into my cells", "The power of Gods love heals me", "The Fountain of Gods love healed me", "The Power of God has healed me", "I am intuitively guided to my healing", "I knew I was healed like God promised", "I am divinely guided to my healing"],
        .Gratitude: ["My body corrected all irregularities", "My body perfectly repaired this", "I'm so grateful my body cleaned it up", "Thank you “body” for letting this go", "Thank you “body” for healing yourself", "I am grateful to be whole, I am healthy in my body"],
        .Self_belief: ["I knew I could heal myself", "I knew I could recover from this", "I knew I would heal myself", "I am healed", "I am strong", "I trust my body to heal"],
        .Intuition: ["My Intuition guided me through this", "I knew Gods love could heal me", "I knew I'd discover ways to heal this", "I am intuitively guided to my healing"],
        .Illness: ["All evidence of cancer is gone", "All evidence of __ is gone (or healed)", "I deserve to be free from ___."],
        .Self_healing: ["My body is full of healing energy", "My nervous system is whole", "My Body knows how to heal itself", "I perceive what my body needs to heal", "I know what my body needs to heal"]
    ]
    
    let affirmationsLove: [CategoryData.Love: [String]] = [
        .Attracting_love: ["I am attracting healthy relationships", "I am attracting true love", "I am attracting romantic love", "I am moving towards a love I can feel proud of"],
        .Self_worth: ["I am worthy of being cherished and deeply cared for", "I am worthy of affection", "I am worthy of love"],
        .Marriage: ["I am in a happy marriage", "I am married and loving it"],
        .Positive_outlook: ["I knew I could find my life-long love", "I am grateful"]
    ]
    
    let affirmationFinance: [CategoryData.Finance: [String]] = [
        .Abundance: ["I manifest abundance easily", "I am worthy of abundance", "Abundance is my birthright"],
        .Wealth: ["I generate amazing sources of income", "I allow wealth to flow into my life", "Money comes to me easily", "I have the power to attract wealth", "I have the power to create wealth"],
        .Income: ["I generate amazing sources of income", "I make money easily", "Everyday I'm getting paid"],
        .Millionaire_mindset: [ "I am a multimillionaire", "I am independently wealthy", "I am rich and loving it"],
        .Confidence: [ "I am confident in my ability", "I am stable financially", "I am abundant and successful", "I am inspired to succeed", "I am strong creative and wealthy", "I knew my hard work would pay off"],
        .Wealth_attraction: ["I allow wealth to flow into my life", "Money comes to me easily", "I have the power to attract wealth"],
        .Money_mastery: ["I make money easily", "I am a deal magnet"],
        .Prosperity: ["I am an abundant being", "Abundance is my birthright", "I am blessed", "favored, and prosperous"],
        .Deal_making: ["I am a deal magnet", "I have the power to create wealth"],
        .Financial_stability: [ "I am stable financially", "I am totally debt free"],
        .Success: [ "I am abundant and successful", "I am inspired to succeed", "I am strong creative and wealthy"],
        .Debt_freedom: ["I am totally debt free"],
        
    ]
    
    let affirmationMentalHealth: [CategoryData.Mental_Health: [String]] = [
        .Healing_from: ["I am healed from anxiety", "Healing from depression is possible", "I am capable of healing depression", "I am healed of depression"],
        .Depression: ["I am managing my depressing thoughts", "I am strong enough to handle this", "I have what it takes to get through this", "I can and will heal from depression", "It’s time to outgrow depression", "I am capable of managing depression symptoms"],
        .Self_acceptance: ["I celebrate the good things about my life", "I celebrate the good things about myself", "I have so much to be grateful for", "I am much more than how I feel right now", "I am worthy of great things in my life"],
        .Inspiration: ["I knew I’d find inspiration to change", "I will find inspiration to change", "My Life’s possibilities are endless", "I knew my mind would be whole", "I am motivated to fight for my life"],
        .Strength: ["I will navigate these feelings with strength and love", "I am mentally strong and stable", "I am optimistic", "I am capable of managing anxiety symptoms"],
        .Self_love: ["I love you", "you are safe"],
        .Spirituality: ["God has given me a sound mind"],
        .Negative_thoughts: ["My repetitive thoughts are not facts", "My subconscious fear patterns are healed", "gain momentum by taking small steps"]
    ]
    
}
