//
//  PromptType.swift
//  EDClient
//
//  Created by Oleksii Chumak on 13.06.2024.
//

import Foundation
import SwiftUI

enum InformationType: String {
    case city = "City"
    case street = "Street"
    case building = "Building"
    
    var localizedName: String {
        switch self {
        case .city:
            String(localized: LocalizedStringResource(stringLiteral: "City"))
        case .street:
            String(localized: LocalizedStringResource(stringLiteral: "Street"))
        case .building:
            String(localized: LocalizedStringResource(stringLiteral: "Building"))
        }
        
    }
    
}


