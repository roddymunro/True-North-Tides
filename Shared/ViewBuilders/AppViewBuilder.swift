//
//  AppViewBuilder.swift
//  True North Tides
//
//  Created by Roddy Munro on 2021-04-14.
//

import SwiftUI

enum AppViewBuilder {
    static func makeSelectStationView(stationRepository: StationRepository) -> some View {
        let viewModel = SelectStationViewModel(stationRepository: stationRepository)
        return SelectStationView(viewModel: viewModel)
    }
}
