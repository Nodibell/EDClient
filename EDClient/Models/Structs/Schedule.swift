//
//  Schedule.swift
//  EDClient
//
//  Created by Oleksii Chumak on 15.06.2024.
//

import Foundation

struct Schedule: Decodable, CustomStringConvertible {
    var description: String {
        "(queue: \(String(describing: queue)), day: \(day), lightTimes: \(lightTimes.description))"
    }
    
    var queue: String?
    var day: String
    var lightTimes: [LightTime]
    
    var isEmpty: Bool {
        queue!.isEmpty && day.isEmpty && lightTimes.isEmpty
    }
    
    init(queue: String, day: String, lightTimes: [LightTime]) {
        self.queue = queue
        self.day = day
        self.lightTimes = lightTimes
    }
    
    init() {
        self.queue = ""
        self.day = ""
        self.lightTimes = []
    }
}
