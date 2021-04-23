//
//  IntentHandler.swift
//  StationIntentExtension
//
//  Created by Roddy Munro on 09/12/2020.
//

import Intents

class IntentHandler: INExtension, SelectStationIntentHandling {
    
    func resolveStation(for intent: SelectStationIntent, with completion: @escaping (INStationResolutionResult) -> Void) {
        //
    }
    
    func provideStationOptionsCollection(for intent: SelectStationIntent, with completion: @escaping (INObjectCollection<INStation>?, Error?) -> Void) {
        let stations: [INStation] = StationRepository(api: StationAPI()).stations.map { station in
            let newStation = INStation(
                identifier: station.id,
                display: "\(station.name), \(station.province.shortened)"
            )
            newStation.name = station.name
            return newStation
        }

        completion(INObjectCollection(items: stations.sorted { $0.name! < $1.name! }), nil)
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
