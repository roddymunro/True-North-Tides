//
//  ErrorModel.swift
//  True North Tides
//
//  Created by Roddy Munro on 09/02/2021.
//

import Foundation

struct ErrorModel: Identifiable, Equatable {
    
    public let id = UUID()
    private(set) var title: String
    private(set) var error: Error
    
    var message: String {
        error.localizedDescription
    }
    
    init(_ title: String, _ error: Error) {
        self.title = title
        self.error = error
    }
    
    static func == (lhs: ErrorModel, rhs: ErrorModel) -> Bool {
        return lhs.error.localizedDescription == rhs.error.localizedDescription
    }
}
