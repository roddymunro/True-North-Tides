//
//  UnitDetail.swift
//  Ceramispace iOS
//
//  Created by Roddy Munro on 2021-04-06.
//  Copyright © 2021 roddy.io. All rights reserved.
//

import Foundation

struct UnitDetail<U: Unit> {
    let unit: U
    let description: String
    let units: String
    let longUnits: String
    let format: String
    
    init(_ unit: U, _ description: String, _ units: String, _ longUnits: String, _ format: String) {
        self.unit = unit
        self.description = description
        self.units = units
        self.longUnits = longUnits
        self.format = format
    }
}
