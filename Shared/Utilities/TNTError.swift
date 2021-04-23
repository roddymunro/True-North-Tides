//
//  TNTError.swift
//  True North Tides
//

import Foundation

enum TNTError: Error {
    case noConnection
    case unableToComplete
    case invalidResponse
    case invalidData
    case noData
}

extension TNTError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noConnection:
            return NSLocalizedString(
                "You are not connected to the internet. Please check your internet connection and try again.",
                comment: ""
            )
        case .unableToComplete:
            return NSLocalizedString(
                "Unable to complete your request. Please check your internet connection and try again.",
                comment: ""
            )
        case .invalidResponse:
            return NSLocalizedString(
                "Invalid response from the server. Please try again.",
                comment: ""
            )
        case .invalidData:
            return NSLocalizedString(
                "The data received from the server was invalid. Please try again.",
                comment: ""
            )
        case .noData:
            return NSLocalizedString(
                "Couldn't find any data for this station. Please contact the developer by going to 'Settings' and tapping 'Contact Us'.",
                comment: ""
            )
        }
    }
}
