//
//  TideType.swift
//  True North Tides
//
//  Created by Roddy Munro on 2021-04-14.
//

import Foundation

enum TideType {
    case low, high
    
    var imageName: String {
        switch self {
            case .high:
                return "arrow.up"
            case .low:
                return "arrow.down"
        }
    }
}
