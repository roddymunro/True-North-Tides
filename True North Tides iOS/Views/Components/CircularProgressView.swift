//
//  CircularProgressView.swift
//  Canada Tidal Schedule
//
//  Created by Roddy Munro on 18/08/2020.
//

import SwiftUI

struct CircularProgressView: View {
    @Binding var progress: Float
    @Binding var date: Date?
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 16.0)
                .opacity(0.3)
                .foregroundColor(.accentColor)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 16.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.accentColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            if let date = date {
                Text(date, style: .relative).font(.headline).fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding()
            }
        }
    }
}

struct iOSCircularProgressView_Previews: PreviewProvider {
    
    static var previews: some View {
        var dayComponent = DateComponents()
        dayComponent.second = 1638
        return CircularProgressView(progress: .constant(0.7), date: .constant(Calendar.current.date(byAdding: dayComponent, to: Date())))
            .frame(width: 150.0, height: 150.0)
            .padding()
    }
}
