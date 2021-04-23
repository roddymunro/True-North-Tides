//
//  AppViewModel.swift
//  True North Tides
//
//  Created by Roddy Munro on 2021-04-14.
//

import Foundation
import Combine
import SwiftUI

class AppViewModel: ObservableObject {
    private let stationRepository: StationRepository
    
    @Published private(set) var stations: [Station] = []
    @Published private(set) var isLoading = false
    @Published private(set) var selectedStation: Station
    
    @Published var activeAlert: ActiveAlert?
    @Published var activeSheet: ActiveSheet?
    
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
    
    public func openSelectStation() {
        activeSheet = .chooseStation
    }
    
    public func openSettings() {
        activeSheet = .settings
    }
    
    public func closeSheet() {
        activeSheet = nil
    }
    
    enum ActiveAlert { case error(_ error: ErrorModel) }
    enum ActiveSheet { case settings, chooseStation }
}

extension AppViewModel {
    var selectStationView: some View {
        AppViewBuilder.makeSelectStationView(stationRepository: stationRepository)
    }
}
