//
//  SelectStationView.swift
//  True North Tides watchOS Extension
//
//  Created by Roddy Munro on 13/09/2020.
//

import SwiftUI

struct SelectStationView: View {
    @ObservedObject var viewModel: SelectStationViewModel
        
    var body: some View {
        NavigationView {
            Form {
                Picker(selection: $viewModel.selectedProvince, label: Text("Province".localized)) {
                    ForEach(Province.all, id: \.rawValue) { province in
                        Text(province.rawValue.localized).tag(province)
                    }
                }.onChange(of: viewModel.selectedProvince) { province in
                    viewModel.setFirstStation(for: province)
                }
                Picker(selection: $viewModel.selectedStation, label: Text("Station".localized)) {
                    ForEach(viewModel.filteredStations) { station in
                        Text(station.name).tag(station)
                    }
                }.onChange(of: viewModel.selectedStation) { station in
                    viewModel.setStation(to: station)
                }
            }
            .navigationTitle("Station".localized)
        }
    }
}
