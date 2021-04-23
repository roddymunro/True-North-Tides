//
//  SelectStationView.swift
//  Canatides
//
//  Created by Roddy Munro on 05/09/2020.
//

import SwiftUI

struct SelectStationView: View {
    
    @ObservedObject private var viewModel: SelectStationViewModel
    
    init(viewModel: SelectStationViewModel) {
        self.viewModel = viewModel
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
    }
    
    var body: some View {
        content
            .alert(using: $viewModel.activeAlert) { alert in
                switch alert {
                    case .error(let error):
                        return Alert(title: Text("Error".localized), message: Text(error.message))
                }
            }
    }
    
    var content: some View {
        Form {
            Section {
                Picker(selection: $viewModel.selectedProvince, label: Text("Province".localized).fontWeight(.medium)) {
                    ForEach(Province.all, id: \.rawValue) { province in
                        Text(province.rawValue.localized).tag(province)
                    }
                }.onChange(of: viewModel.selectedProvince) { province in
                    viewModel.setFirstStation(for: province)
                }
                Picker(selection: $viewModel.selectedStation, label: Text("Station".localized).fontWeight(.medium)) {
                    SearchBar(placeholder: "Search Stations".localized, text: $viewModel.searchTerm).frame(height: 60)
                        .onDisappear(perform: viewModel.clearSearchTerm)
                    ForEach(viewModel.filteredStations) { station in
                        Text(station.name).tag(station)
                    }
                }.onChange(of: viewModel.selectedStation) { station in
                    viewModel.setStation(to: station)
                }
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label(title: { Text("Why is my province not listed?".localized).fontWeight(.semibold) }, icon: { Image(systemName: "info.circle") })
                    
                    Text("Some provinces may not be shown due to the lack of a Canadian Hydrographic Service (CHS) station. Stations are typically located in an ocean, the sea or a significant lake. For more information, please visit the CHS website.".localized).font(.callout).fontWeight(.regular)
                    
                    Button(action: viewModel.openCHSWebsite) {
                        Text("CHS Website".localized).font(.headline).fontWeight(.semibold)
                    }.foregroundColor(.accentColor)
                }
            }
        }.padding(.horizontal, -20)
    }
}
