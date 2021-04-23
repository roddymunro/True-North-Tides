//
//  SelectStationViewModel.swift
//  True North Tides
//
//  Created by Roddy Munro on 2021-04-14.
//

import Foundation
import Combine
import UIKit

class SelectStationViewModel: ObservableObject {
    private let stationRepository: StationRepository
    
    @Published private var stations: [Station] = []
    @Published var selectedStation: Station
    @Published var selectedProvince: Province
    
    @Published var searchTerm: String = ""
    
    @Published var activeAlert: ActiveAlert?
    
    var filteredStations: [Station] {
        stations.filter { $0.province == selectedProvince && $0.matchesSearch(searchTerm) }
    }
    
    init(stationRepository: StationRepository) {
        self.stationRepository = stationRepository
        self.stations = stationRepository.stations
        self.selectedStation = stationRepository.selectedStation
        self.selectedProvince = stationRepository.selectedStation.province
        self.stationRepository.stationsPublisher
            .assign(to: &$stations)
        self.stationRepository.selectedStationPublisher
            .assign(to: &$selectedStation)
    }
    
    public func setFirstStation(for province: Province) {
        if let station = stations.first(where: { $0.province == province }) {
            setStation(to: station)
        }
    }
    
    public func setStation(to station: Station) {
        stationRepository.setStation(station)
        loadHiLoTides()
    }
    
    public func clearSearchTerm() {
        searchTerm = ""
    }
    
    public func loadHiLoTides() {
        stationRepository.getHiLoTides { result in
            switch result {
                case .success:
                    break
                case .failure(let error):
                    self.activeAlert = .error(.init("Couldn't Get Tides", error))
            }
        }
    }
    
    #if os(iOS)
    public func openCHSWebsite() {
        UIApplication.shared.open(URL(string: "https://tides.gc.ca/eng".localized)!)
    }
    #endif
    
    enum ActiveAlert { case error(_ error: ErrorModel) }
}
