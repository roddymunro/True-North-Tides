//
//  TideView.swift
//  True North Tides watchOS Extension
//
//  Created by Roddy Munro on 05/09/2020.
//
import SwiftUI

struct TideView: View {
    @ObservedObject var viewModel: WatchAppViewModel
    var tideType: TideType
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                CircularProgressView(station: viewModel.selectedStation, tideType: tideType)
                    .frame(width: 116.0, height: 116.0)
                    .padding([.top, .horizontal], 16)
                    .padding(.bottom, 8)
                Text(viewModel.selectedStation.displayName)
                    .font(.caption2)
            }
            .navigationTitle(tideType == .high ? "High Tide".localized : "Low Tide".localized)
        }
    }
}
