//
//  CircularProgressView.swift
//  Canada Tidal Schedule
//
//  Created by Roddy Munro on 18/08/2020.
//

import SwiftUI

struct CircularProgressView: View {
    
    var station: Station
    var tideType: TideType
    
    @State var progress: Float = 0
    @State private var date: Date?
    @State var height = ""
    
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 12.0)
                .opacity(0.3)
                .foregroundColor(.accentColor)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.accentColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            if let date = date {
                VStack(alignment: .center, spacing: 0) {
                    Text(date, style: .relative).font(.caption).fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 4)
                    Label(height, systemImage: tideType.imageName)
                        .font(.caption2)
                }
            } else {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            }
        }
        .onReceive(timer) { _ in
            progress = calculateProgress()
            date = tideType == .low ? station.minReadings.first { $0.isFuture }?.dateTime : station.maxReadings.first { $0.isFuture }?.dateTime
            height = tideType == .low ? station.minReadings.first { $0.isFuture }?.heightString ?? "" : station.maxReadings.first { $0.isFuture }?.heightString ?? ""
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
