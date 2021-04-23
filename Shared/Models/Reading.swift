//
//  Reading.swift
//  True North Tides
//
//  Created by Roddy Munro on 2021-04-14.
//

import Foundation

struct Reading: Hashable, Identifiable {
    let id = UUID().uuidString
    var dateTime: Date
    var height: Measurement<UnitLength>
    
    var isHigh: Bool = true
    
    var isFuture: Bool {
        return dateTime > Date()
    }
    
    var time: String {
        if Calendar.current.isDateInToday(dateTime) {
            return "\("Today at".localized) \(dateTime.convertToTime())"
        } else if Calendar.current.isDateInTomorrow(dateTime) {
            return "\("Tomorrow at".localized) \(dateTime.convertToTime())"
        } else {
            return dateTime.convertToDateTime()
        }
    }
    
    var shortTime: String {
        dateTime.convertToTime()
    }
    
    var convertedHeight: Double {
        height.converted(to: .preferred).value
    }
    
    var heightString: String {
        "\(String(format: UnitLength.preferredFormat, convertedHeight))\(UnitLength.preferredUnit)"
    }
}
