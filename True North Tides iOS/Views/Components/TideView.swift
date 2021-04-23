//
//  TideView.swift
//  Canatides
//
//  Created by Roddy Munro on 05/09/2020.
//

import SwiftUI

struct TideView: View {
    
    var station: Station
    var tideType: TideType = .low
    
    @State var progress: Float = 0
    @State var date: Date?
    
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .center) {
            CircularProgressView(progress: $progress, date: $date)
                .frame(width: 150.0, height: 150.0)
                .padding()
            HStack {
                if let reading = tideType == .low ? station.minReadings.first { $0.isFuture } : station.maxReadings.first { $0.isFuture } {
                    Spacer()
                    VStack(spacing: 4) {
                        Text(tideType == .low ? "Low Tide".localized : "High Tide".localized).font(.title2).fontWeight(.medium)
                        Text("\(String(format: UnitLength.preferredFormat, reading.convertedHeight))\(UnitLength.preferredUnit)").font(.title3).fontWeight(.bold)
                        Text(reading.time).font(.headline).fontWeight(.semibold)
                            .fixedSize(horizontal: true, vertical: false)
                    }.multilineTextAlignment(.center).padding(2)
                    Spacer()
                }
            }
        }
        .onReceive(timer) { _ in
            progress = calculateProgress()
            date = tideType == .low ? station.minReadings.first { $0.isFuture }?.dateTime : station.maxReadings.first { $0.isFuture }?.dateTime
        }
    }
    
    func calculateProgress() -> Float {
        let prev = tideType == .low ? station.minReadings.last { !$0.isFuture } : station.maxReadings.last { !$0.isFuture }
        let next = tideType == .low ? station.minReadings.first { $0.isFuture } : station.maxReadings.first { $0.isFuture }
        
        guard let prevTime = prev?.dateTime else { return 0 }
        guard let nextTime = next?.dateTime else { return 0 }
        
        let differenceBetweenReadings = nextTime.timeIntervalSince(prevTime)
        let differenceFromNow = Date().timeIntervalSince(prevTime)
        return Float(differenceFromNow / differenceBetweenReadings)
    }
}
