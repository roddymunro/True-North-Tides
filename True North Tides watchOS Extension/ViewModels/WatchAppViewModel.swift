//
//  WatchAppViewModel.swift
//  True North Tides
//
//  Created by Roddy Munro on 03/08/2020.
//

import Foundation
import Combine
import SwiftUI

class WatchAppViewModel: ObservableObject {
    private let stationRepository: StationRepository
    
    @Published private(set) var stations: [Station] = []
    @Published private(set) var isLoading = false
    @Published private(set) var selectedStation: Station
    
    @Published var activeAlert: ActiveAlert?
    
    public var selectedProvince: Province {
        selectedStation.province
    }
    
    init(stationRepository: StationRepository) {
        self.stationRepository = stationRepository
        self.stations = stationRepository.stations
        self.selectedStation = stationRepository.selectedStation
        self.stationRepository.stationsPublisher
            .assign(to: &$stations)
        self.stationRepository.selectedStationPublisher
            .assign(to: &$selectedStation)
        loadHiLoTides()
    }
    
    public func loadHiLoTides() {
        isLoading = true
        stationRepository.getHiLoTides { result in
            switch result {
                case .success:
                    self.isLoading = false
                case .failure(let error):
                    self.isLoading = false
                    self.activeAlert = .error(.init("Couldn't Get Tides", error))
            }
        }
    }
    
    enum ActiveAlert { case error(_ error: ErrorModel) }
}

extension WatchAppViewModel {
    var selectStationView: some View {
        AppViewBuilder.makeSelectStationView(stationRepository: stationRepository)
    }
}
