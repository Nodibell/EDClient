//
//  DisconnectionType.swift
//  EDClient
//
//  Created by Oleksii Chumak on 14.06.2024.
//

import Foundation
import SwiftUI

enum LightStatus: Int, Decodable, Hashable {
    case disconnected = 2
    case posibleDisconnection = 1
    case connected = 0
    
    var image: Image? {
        switch self {
        case .disconnected:
            return Image(systemName: "bolt.slash")
        case .posibleDisconnection:
            return Image(systemName: "bolt.trianglebadge.exclamationmark.fill")
        case .connected:
            return Image(systemName: "bolt.fill")
        }
    }
}
