//
//  String+Ext.swift
//  Canada Tidal Schedule
//
//  Created by Roddy Munro on 03/08/2020.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
}
