//
//  SpecifiedDateFormat.swift
//  EDClient
//
//  Created by Oleksii Chumak on 20.06.2024.
//

import Foundation

class SpecifiedDateFormat {
    static let shared = SpecifiedDateFormat()
    let currentDate = Date()
    
    let dateFormatter = DateFormatter()
    
    private init() {
        dateFormatter.dateFormat = "E dd.MM"
        dateFormatter.locale = Locale.current
    }
    
    var todayDate: String {
        return dateFormatter.string(from: currentDate)
    }
}
