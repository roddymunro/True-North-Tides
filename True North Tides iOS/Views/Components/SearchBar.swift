//
//  SearchBar.swift
//  True North Tides
//
//  Created by Roddy Munro on 2021-04-14.
//

import SwiftUI

public struct SearchBar: View {
    private var placeholder: String
    @Binding private var text: String
    
    public init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    private var foregroundColor: Color {
        #if !os(macOS)
        return Color(.systemGray3)
        #else
        return Color(.gray)
        #endif
    }
    
    private var backgroundColor: Color {
        #if !os(macOS)
        return Color(.systemBackground)
        #else
        return Color(.darkGray)
        #endif
    }
  
    public var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
            TextField(placeholder, text: $text)
            if text != "" {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.medium)
                    .foregroundColor(foregroundColor)
                    .padding(3)
                    .onTapGesture {
                        withAnimation {
                            self.text = ""
                        }
                    }
            }
        }
        .padding(10)
        .background(backgroundColor)
        .cornerRadius(12)
        .padding(.vertical, 10)
    }
}
