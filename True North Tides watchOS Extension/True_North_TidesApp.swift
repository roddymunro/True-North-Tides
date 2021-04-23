//
//  True_North_TidesApp.swift
//  True North Tides watchOS Extension
//
//  Created by Roddy Munro on 05/09/2020.
//

import SwiftUI

@main
struct True_North_TidesApp: App {
    @StateObject private var viewModel: WatchAppViewModel
    
    init() {
        let repository = StationRepository(api: StationAPI())
        self._viewModel = StateObject(wrappedValue: WatchAppViewModel(stationRepository: repository))
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                TideView(viewModel: viewModel, tideType: .high)
                    .tabItem { Label("High Tide".localized, systemImage: "arrow.up") }
                TideView(viewModel: viewModel, tideType: .low)
                    .tabItem { Label("Low Tide".localized, systemImage: "arrow.down") }
                viewModel.selectStationView
                    .tabItem { Label("Choose Station".localized, systemImage: "gear") }
            }
        }
    }
}
