//
//  DisconnectionType.swift
//  EDClient
//
//  Created by Oleksii Chumak on 14.06.2024.
//

import Foundation
import SwiftUI

enum Status: Int, Decodable, Hashable {
    case disconnected = 0
    case posibleDisconnection = 1
    case connected = 2
    
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
