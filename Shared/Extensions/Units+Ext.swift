//
//  Units+Ext.swift
//  Ceramispace
//
//  Created by Roddy Munro on 29/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

extension UnitLength {
    static let all: [UnitDetail<UnitLength>] = [
        .init(.meters, "Meters (m)".localized, "m".localized, "meters".localized, "%.2f"),
        .init(.centimeters, "Centimeters (cm)".localized, "cm".localized, "centimeters".localized, "%.0f"),
        .init(.feet, "Feet (ft)".localized, "ft".localized, "feet".localized, "%.1f"),
        .init(.inches, "Inches (in)".localized, "in".localized, "inches".localized, "%.1f")
    ]
    
    static var preferred: UnitLength {
        let lengthUnitsIdx = UserDefaults(suiteName: "group.com.roddy.io.TrueNorthTides")?.integer(forKey: "lengthUnitsIdx") ?? 0
        return self.all[lengthUnitsIdx].unit
    }
    
    static var preferredDescription: String {
        let lengthUnitsIdx = UserDefaults(suiteName: "group.com.roddy.io.TrueNorthTides")?.integer(forKey: "lengthUnitsIdx") ?? 0
        return self.all[lengthUnitsIdx].description
    }
    
    static var preferredUnit: String {
        let lengthUnitsIdx = UserDefaults(suiteName: "group.com.roddy.io.TrueNorthTides")?.integer(forKey: "lengthUnitsIdx") ?? 0
        return self.all[lengthUnitsIdx].units
    }
    
    static var preferredUnitLong: String {
        let lengthUnitsIdx = UserDefaults(suiteName: "group.com.roddy.io.TrueNorthTides")?.integer(forKey: "lengthUnitsIdx") ?? 0
        return self.all[lengthUnitsIdx].longUnits
    }
    
    static var preferredFormat: String {
        let lengthUnitsIdx = UserDefaults(suiteName: "group.com.roddy.io.TrueNorthTides")?.integer(forKey: "lengthUnitsIdx") ?? 0
        return self.all[lengthUnitsIdx].format
    }
}
