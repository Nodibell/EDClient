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
    let status: LightStatus
    
    init(time: String, status: LightStatus) {
        self.time = time
        self.status = status
    }
    
    init() {
        self.time = ""
        self.status = .connected
    }
}
