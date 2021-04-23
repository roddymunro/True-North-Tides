//
//  TrueNorthTidesApp.swift
//  True North Tides
//
//  Created by Roddy Munro on 03/08/2020.
//

import SwiftUI

@main
struct TrueNorthTidesApp: App {
    @StateObject private var viewModel: AppViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: AppViewModel(stationRepository: StationRepository(api: StationAPI())))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
