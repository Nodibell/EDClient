//
//  LightTime.swift
//  EDClient
//
//  Created by Oleksii Chumak on 15.06.2024.
//

import Foundation

struct LightTime: Decodable, CustomStringConvertible {
    var description: String {
        "(time: \(time), status: \(status))"
    }
    
    let time: String
    let status: Status
    
    init(time: String, status: Status) {
        self.time = time
        self.status = status
    }
    
    init() {
        self.time = ""
        self.status = .connected
    }
}
