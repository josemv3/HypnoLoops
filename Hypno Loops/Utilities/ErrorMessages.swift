//
//  ErrorMessages.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/6/23.
//

import UIKit

enum ErrorMessage {
    case invalidUsername, invalidEmail, invalidPassword_Count,
         invalidPassword_NeedDigit, invalidPassword_NeedUppercase,
         invalidPassword_NeedLowercase
    
    var displayError: String {
        switch self {
        case .invalidUsername:
            return "Username must have at least 3 characters"
        case .invalidEmail:
            return "Invalid Email Address"
        case .invalidPassword_Count:
            return "Password must be at least 8 characters"
        case .invalidPassword_NeedDigit:
            return "Password must contain at least 1 digit"
        case .invalidPassword_NeedUppercase:
            return "Password must contain at least 1 uppercase letter"
        case .invalidPassword_NeedLowercase:
            return "Password must contain at least 1 lowercase letter"
        }
    }
}
