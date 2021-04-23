//
//  Station.swift
//  True North Tides
//
//  Created by Roddy Munro on 2021-04-14.
//

import Foundation
import CoreLocation

struct Station: Identifiable, Hashable, Equatable {
    var id: String
    var name: String
    var province: Province
    var lat: Double
    var lon: Double
    var readings: [Reading] = []
    
    var displayName: String {
        "\(name), \(province.shortened)"
    }
    
    var minReadings: [Reading] {
        var temp: [Reading] = []
        if readings.count == 1 {
            temp.append(readings[0])
        } else if readings.count > 1 {
            if readings[0].height < readings[1].height {
                temp = stride(from: 0, to: readings.count, by: 2).map { readings[$0] }
            } else {
                temp = stride(from: 1, to: readings.count, by: 2).map { readings[$0] }
            }
        }
        return temp
    }
    
    var maxReadings: [Reading] {
        var temp: [Reading] = []
        if readings.count == 1 {
            temp.append(readings[0])
        } else if readings.count > 1 {
            if readings[0].height > readings[1].height {
                temp = stride(from: 0, to: readings.count, by: 2).map { readings[$0] }
            } else {
                temp = stride(from: 1, to: readings.count, by: 2).map { readings[$0] }
            }
        }
        return temp
    }
    
    func matchesSearch(_ searchTerm: String) -> Bool {
        let searchTerm = searchTerm.uppercased()
        guard !searchTerm.isEmpty else { return true }
        
        if name.uppercased().contains(searchTerm) {
            return true
        } else if province.localized.uppercased().contains(searchTerm) {
            return true
        } else {
            return false
        }
    }
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    static func == (lhs: Station, rhs: Station) -> Bool {
        lhs.id == rhs.id
    }
}

extension Station {
    static let dummy = Station(id: "00065", name: "Saint John", province: .nb, lat: 0, lon: 0, readings: [
        .init(dateTime: Date().addingTimeInterval(-9381), height: .init(value: 7.2, unit: .meters), isHigh: true),
        .init(dateTime: Date().addingTimeInterval(-3581), height: .init(value: 1.4, unit: .meters), isHigh: false),
        .init(dateTime: Date().addingTimeInterval(7964), height: .init(value: 7.4, unit: .meters), isHigh: true),
        .init(dateTime: Date().addingTimeInterval(12582), height: .init(value: 1.6, unit: .meters), isHigh: false)
    ])
}
