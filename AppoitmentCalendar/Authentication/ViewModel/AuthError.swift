//
//  AuthError.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 3. 8. 2025..
//

import SwiftUI

// MARK: - Error Handling
enum AuthError: LocalizedError {
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case encodingError
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .emailAlreadyInUse:
            return "This email is already in use"
        case .weakPassword:
            return "Password is too weak"
        case .networkError:
            return "Network error, please try again"
        case .encodingError:
            return "Failed to encode user data"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
