//
//  SettingsView.swift
//  Canada Tidal Schedule
//
//  Created by Roddy Munro on 29/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    static let ud = UserDefaults(suiteName: "group.com.roddy.io.TrueNorthTides")!
    @AppStorage("lengthUnitsIdx", store: ud) var lengthUnitsIdx: Int = 0
    
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Tip the Developer".localized).font(.caption)) {
                Button(action: viewModel.tipDeveloper, label: {
                    Label("Tip the Developer".localized, systemImage: "dollarsign.circle").font(Font.body.weight(.medium))
                }).buttonStyle(PlainButtonStyle())
            }
            
            Section(header: Text("Units of Measurement".localized).font(.caption)) {
                Picker(selection: $lengthUnitsIdx, label: Label("Height".localized, systemImage: "ruler")) {
                    ForEach(0 ..< UnitLength.all.count) { index in
                        Text(UnitLength.all[index].description).tag(index)
                    }
                }
            }
            
            Section(header: Text("Leave a Review".localized).font(.caption)) {
                Button(action: viewModel.rateUsTapped, label: {
                    Label("Leave a Review".localized, systemImage: "star").font(Font.body.weight(.medium))
                }).buttonStyle(PlainButtonStyle())
            }
            
            Section(header: Text("Meet the Maker".localized).font(.caption)) {
                Button(action: {
                    viewModel.openUrl("https://roddy.io")
                }, label: {
                    Label("Website".localized, systemImage: "person").font(Font.body.weight(.medium))
                }).buttonStyle(PlainButtonStyle())
                
                Button(action: viewModel.twitterTapped, label: {
                    Label("Twitter".localized, systemImage: "t.bubble").font(Font.body.weight(.medium))
                }).buttonStyle(PlainButtonStyle())
            }
            
            Section(
                header: Text("With Thanks To".localized).font(.caption),
                footer: Text("\("Version".localized) \(viewModel.appVersion)").font(.caption).fontWeight(.bold)
            ) {
                Button(action: {
                    viewModel.openUrl("http://www.tides.gc.ca/eng/info/Licence")
                }, label: {
                    Label("Canadian Hydrographic Service".localized, systemImage: "drop").font(Font.body.weight(.medium))
                }).buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    viewModel.openUrl("https://github.com/100mango/SwiftXMLParser")
                }, label: {
                    Label("SwiftXMLParser", systemImage: "chevron.left.slash.chevron.right").font(Font.body.weight(.medium))
                }).buttonStyle(PlainButtonStyle())
            }
        }
        .navigationTitle("Settings".localized)
        .alert(using: $viewModel.activeAlert) { alert in
            switch alert {
                case .thankYou:
                    return Alert(title: Text("Thank you!".localized))
            }
        }
    }
}
