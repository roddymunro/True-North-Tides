//
//  CircularProgressView.swift
//  Canada Tidal Schedule
//
//  Created by Roddy Munro on 18/08/2020.
//

import SwiftUI

struct CircularProgressView: View {
    
    var tideType: TideType
    var station: Station
    
    var reading: Reading? {
        tideType == .low ? station.minReadings.first { $0.isFuture } : station.maxReadings.first { $0.isFuture }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.3)
                .foregroundColor(.accentColor)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(calculateProgress(), 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.accentColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            if !station.readings.isEmpty {
                VStack(spacing: 4) {
                    Text(reading?.dateTime ?? Date(), style: .relative).font(.caption).fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .frame(width: 86.0, height: 40.0)
                        .padding([.horizontal, .top], 8)
                    HStack(spacing: 2) {
                        Image(systemName: tideType.imageName)
                            .imageScale(.medium)
                        Text(reading?.heightString ?? "").font(.caption).fontWeight(.semibold)
                    }
                }
            } else {
                VStack(spacing: 4) {
                    Text("Loading".localized).font(.headline).fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding([.horizontal, .top], 8)
                    Image(systemName: tideType.imageName)
                        .imageScale(.medium)
                }.redacted(reason: .placeholder)
            }
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
