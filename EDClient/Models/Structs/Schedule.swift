//
//  Schedule.swift
//  EDClient
//
//  Created by Oleksii Chumak on 15.06.2024.
//

import Foundation

struct Schedule: Decodable, CustomStringConvertible {
    var description: String {
        "(queueName: \(String(describing: queueName)), date: \(String(describing: date?.description)), disconnections: \(disconnections.description))"
    }
    
    var queueName: String?
    var date: String?
    var disconnections: [LightTime]
    
    var isEmpty: Bool {
        queueName?.isEmpty ?? true && date?.isEmpty ?? true  && disconnections.isEmpty
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
