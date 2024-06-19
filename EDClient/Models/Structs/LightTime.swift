//
//  LightTime.swift
//  EDClient
//
//  Created by Oleksii Chumak on 15.06.2024.
//

import Foundation

struct LightTime: Decodable, CustomStringConvertible {
    var description: String {
        "(time: \(Time), status: \(Status))"
    }
    
    let Time: String
    let Status: Status
    
    init(time: String, status: Status) {
        self.Time = time
        self.Status = status
    }
    
    init() {
        self.Time = ""
        self.Status = .connected
    }
}
