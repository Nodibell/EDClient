//
//  Schedule.swift
//  EDClient
//
//  Created by Oleksii Chumak on 15.06.2024.
//

import Foundation

struct Schedule: Decodable, CustomStringConvertible {
    var description: String {
        "(queue: \(String(describing: QueueName)), day: \(Date), lightTimes: \(Disconnections.description))"
    }
    
    var QueueName: String?
    var Date: String
    var Disconnections: [LightTime]
    
    var isEmpty: Bool {
        QueueName!.isEmpty && Date.isEmpty && Disconnections.isEmpty
    }
    
    init(QueueName: String, Date: String, Disconnections: [LightTime]) {
        self.QueueName = QueueName
        self.Date = Date
        self.Disconnections = Disconnections
    }
    
    init() {
        self.QueueName = ""
        self.Date = ""
        self.Disconnections = []
    }
}
