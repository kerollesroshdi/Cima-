//
//  AppError.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/30/21.
//

import Foundation

enum AppError: Error, Equatable {
    case offline
    case networkError
    case notFound
    case with(message: String)
    case empty
    case timeout
    case unauthorized
    case badRequest
    case serverError
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .offline:
            return NSLocalizedString("error_offline", comment: "Offline")
        case .networkError:
            return NSLocalizedString("error_serverError", comment: "Network error")
        case .notFound:
            return NSLocalizedString("error_notFound", comment: "Not found")
        case .with(let message):
            return NSLocalizedString(message, comment: "Server error message")
        case .empty:
            return NSLocalizedString("error_empty", comment: "No Data")
        case .timeout:
            return NSLocalizedString("error_timeout", comment: "Connection timeout")
        case .unauthorized:
            return NSLocalizedString("error_unauthorized", comment: "Unauthorized")
        case .badRequest:
            return NSLocalizedString("error_badRequest", comment: "Bad Request")
        case .serverError:
            return NSLocalizedString("error_serverError", comment: "Internal Server Error")
        }
    }
}

extension AppError {
    
    var image: String {
        switch self {
        case .offline:
            return ""
        case .networkError:
            return ""
        case .notFound:
            return ""
        case .with:
            return ""
        case .empty:
            return ""
        case .timeout:
            return ""
        case .unauthorized:
            return ""
        case .badRequest:
            return ""
        case .serverError:
            return ""
        }
    }
    
}
