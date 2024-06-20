//
//  Schedule.swift
//  EDClient
//
//  Created by Oleksii Chumak on 15.06.2024.
//

import Foundation

struct Schedule: Decodable, CustomStringConvertible {
    var description: String {
        "(queue: \(String(describing: queueName)), day: \(date), lightTimes: \(disconnections.description))"
    }
    
    var queueName: String?
    var date: String
    var disconnections: [LightTime]
    
    var isEmpty: Bool {
        queueName!.isEmpty && date.isEmpty && disconnections.isEmpty
    }
    
    init(queueName: String, date: String, disconnections: [LightTime]) {
        self.queueName = queueName
        self.date = date
        self.disconnections = disconnections
    }
    
    init() {
        self.queueName = ""
        self.date = ""
        self.disconnections = []
    }
}
