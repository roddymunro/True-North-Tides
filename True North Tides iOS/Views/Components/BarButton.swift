//
//  BarButton.swift
//  SatNow
//
//  Created by Roddy Munro on 05/05/2020.
//  Copyright © 2020 Roddy Munro. All rights reserved.
//

import SwiftUI

struct BarButton: View {
    var iconName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .imageScale(.large)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .foregroundColor(.accentColor)
        }
    }
}

struct BarTextButton: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text).font(.headline).fontWeight(.medium)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .foregroundColor(.accentColor)
        }
    }
}

struct BarNavigationButton<Destination: View>: View {
    var iconName: String
    var destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            Image(systemName: iconName)
                .imageScale(.large)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .foregroundColor(.accentColor)
        }
    }
}
