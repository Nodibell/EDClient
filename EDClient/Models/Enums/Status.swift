//
//  DisconnectionType.swift
//  EDClient
//
//  Created by Oleksii Chumak on 14.06.2024.
//

import Foundation
import SwiftUI

enum Status: String, Decodable, Hashable {
    case disconnected = "disconnected"
    case possibleDisconnection = "possibleDisconnection"
    case connected = "connected"
    
    var image: Image? {
        switch self {
        case .disconnected:
            return Image(systemName: "bolt.slash")
        case .possibleDisconnection:
            return Image(systemName: "bolt.trianglebadge.exclamationmark.fill")
        case .connected:
            return Image(systemName: "bolt.fill")
        }
    }
}
