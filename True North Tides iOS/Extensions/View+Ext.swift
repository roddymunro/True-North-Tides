//
//  View+Ext.swift
//  Canada Tidal Schedule
//
//  Created by Roddy Munro on 01/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
    
    var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    public func sheet<Content: View, Value>(
        using value: Binding<Value?>,
        @ViewBuilder content: @escaping (Value) -> Content
    ) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )
        return sheet(isPresented: binding) {
            content(value.wrappedValue!)
        }
    }
    
    public func alert<Value>(
        using value: Binding<Value?>,
        content: (Value) -> Alert
    ) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )
        return alert(isPresented: binding) {
            content(value.wrappedValue!)
        }
    }
    
    public func fullScreenCover<Content: View, Value>(
        using value: Binding<Value?>,
        @ViewBuilder content: @escaping (Value) -> Content
    ) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )
        return fullScreenCover(isPresented: binding) {
            content(value.wrappedValue!)
        }
    }
    
    public func actionSheet<Value>(
        using value: Binding<Value?>,
        content: (Value) -> ActionSheet
    ) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )
        return actionSheet(isPresented: binding) {
            content(value.wrappedValue!)
        }
    }
}
