//
//  StationRepository.swift
//  True North Tides
//
//  Created by Roddy Munro on 2021-04-14.
//

import Foundation
import Combine
#if !os(watchOS)
import WidgetKit
#endif

final class StationRepository {
    
    private let ud = UserDefaults(suiteName: "group.com.roddy.io.TrueNorthTides")!
    private let api: StationAPI
    
    private(set) var stations: [Station] = [] {
        didSet { self.stationsSubject.send(stations) }
    }
    private let stationsSubject = PassthroughSubject<[Station], Never>()
    public var stationsPublisher: AnyPublisher<[Station], Never> {
        stationsSubject.eraseToAnyPublisher()
    }
    
    private(set) var selectedStation: Station! {
        didSet { didSelectStation() }
    }
    private let selectedStationSubject = PassthroughSubject<Station, Never>()
    public var selectedStationPublisher: AnyPublisher<Station, Never> {
        selectedStationSubject.eraseToAnyPublisher()
    }
    
    init(api: StationAPI, defaultStationId: String?=nil) {
        self.api = api
        self.parseStations()
        
        var chosenStationId: String = defaultStationId ?? ud.string(forKey: "chosenStationId") ?? "00065"
        if chosenStationId == "" {
            chosenStationId = "00065"
        }
        
        selectedStation = stations.first { $0.id == chosenStationId }!
    }
    
    private func didSelectStation() {
        ud.set(selectedStation.id, forKey: "chosenStationId")
        ud.synchronize()
        #if !os(watchOS)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
        
        self.selectedStationSubject.send(selectedStation)
    }
    
    private func parseStations() {
        if let path = Bundle.main.path(forResource: "stations", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let myJSON = try JSONSerialization.jsonObject( with: data, options: .mutableContainers) as? Dictionary<String, Any>
                
                if let parsedStations = myJSON?["stations"] as? [[String: Any]] {
                    self.stations = parsedStations.map { station in
                        Station(
                            id: station["id"] as! String,
                            name: station["name"] as! String,
                            province: Province.init(rawValue: station["province"] as! String)!,
                            lat: station["lat"] as! Double,
                            lon: station["lon"] as! Double
                        )
                    }
                }
            } catch let error {
                print("unable to parse json: \(error)")
            }
        }
    }
    
    public func setStation(_ station: Station) {
        selectedStation = station
    }
    
    public func getHiLoTides(_ completion: @escaping (Result<[Reading], Error>) -> Void) {
        api.getHiLoTides(for: selectedStation) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let readings):
                        var temp = readings
                        if temp.count == 1 {
                            temp[0].isHigh = true
                        } else if temp.count > 1 {
                            for idx in temp.indices {
                                if idx < temp.count - 1 {
                                    temp[idx].isHigh = temp[idx].height > temp[idx+1].height
                                } else {
                                    temp[idx].isHigh = temp[idx].height > temp[idx-1].height
                                }
                            }
                        }
                        self.selectedStation.readings = temp
                        completion(.success(temp))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
}
