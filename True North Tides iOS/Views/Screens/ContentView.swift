//
//  ContentView.swift
//  Bay of Fundy Tidal Times
//
//  Created by Roddy Munro on 03/08/2020.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        content
            .navigationViewStyle(StackNavigationViewStyle())
            .alert(using: $viewModel.activeAlert) { alert in
                switch alert {
                    case .error(let error):
                        return Alert(title: Text("Error".localized), message: Text(error.message))
                }
            }
            .sheet(using: $viewModel.activeSheet) { sheet in
                switch sheet {
                    case .settings:
                        NavigationView {
                            SettingsView(viewModel: SettingsViewModel())
                                .navigationTitle("Settings".localized)
                                .navigationBarItems(trailing: BarTextButton(text: "Close".localized, action: viewModel.closeSheet))
                                .navigationBarTitleDisplayMode(.inline)
                        }
                    case .chooseStation:
                        NavigationView {
                            viewModel.selectStationView
                                .navigationTitle("Choose Station".localized)
                                .navigationBarItems(trailing: BarTextButton(text: "Close".localized, action: viewModel.closeSheet))
                                .navigationBarTitleDisplayMode(.inline)
                        }
                }
            }
    }
    
    var content: some View {
        NavigationView {
            VStack {
                toolbar
                tidalInfo
                futureTidesList
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
    var toolbar: some View {
        HStack {
            Image("").frame(width: 60, height: 60)
            Spacer()
            Button(action: viewModel.openSelectStation) {
                HStack {
                    VStack {
                        Text("True North Tides").font(.caption)
                        Text(viewModel.selectedStation.displayName).fontWeight(.bold)
                    }
                    Image(systemName: "arrowtriangle.down.fill")
                        .imageScale(.small)
                }
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Button(action: viewModel.openSettings, label: {
                Image(systemName: "gear").imageScale(.large)
            }).padding().foregroundColor(.accentColor)
        }
    }
    
    var tidalInfo: some View {
        HStack {
            Spacer()
            TideView(station: viewModel.selectedStation, tideType: .low)
            Spacer()
            Divider()
            Spacer()
            TideView(station: viewModel.selectedStation, tideType: .high)
            Spacer()
        }
    }
    
    var futureTidesList: some View {
        VStack(alignment: .leading) {
            Text("Future Tides".localized).font(.callout).foregroundColor(.secondary).padding([.horizontal, .top])
            List(viewModel.selectedStation.readings.filter { $0.isFuture }) { reading in
                HStack {
                    Image(systemName: reading.isHigh ? "arrow.up" : "arrow.down")
                        .imageScale(.medium)
                        .padding()
                    Text(reading.heightString).fontWeight(.medium)
                    Spacer()
                    Text(reading.time)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}
