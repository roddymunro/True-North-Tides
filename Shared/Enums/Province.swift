//
//  Province.swift
//  True North Tides
//
//  Created by Roddy Munro on 2021-04-14.
//

import Foundation

enum Province: StringLiteralType, Codable {
    case ab = "Alberta"
    case bc = "British Columbia"
    case mb = "Manitoba"
    case nb = "New Brunswick"
    case nl = "Newfoundland & Labrador"
    case nt = "Northwest Territories"
    case ns = "Nova Scotia"
    case nu = "Nunavut"
    case on = "Ontario"
    case pe = "Prince Edward Island"
    case qc = "Quebec"
    case sk = "Saskatchewan"
    case yt = "Yukon"
    
    static let all: [Province] = [
        .bc, .mb, .nb, .nl, .nt, .ns, .nu, .on, .pe, .qc, .yt
    ]
    
    var shortened: String {
        switch self {
            case .ab: return "AB"
            case .bc: return "BC"
            case .mb: return "MB"
            case .nb: return "NB"
            case .nl: return "NL"
            case .nt: return "NT"
            case .ns: return "NS"
            case .nu: return "NU"
            case .on: return "ON"
            case .pe: return "PE"
            case .qc: return "QC"
            case .sk: return "SK"
            case .yt: return "YT"
        }
    }
    
    var localized: String {
        self.rawValue.localized
    }
}
