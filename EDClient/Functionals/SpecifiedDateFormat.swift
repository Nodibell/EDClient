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
    
    var todayDate: String {
        dateFormatter.dateFormat = "E dd.MM"
        return dateFormatter.string(for: currentDate)!
    }
    
    private init() {
        dateFormatter.locale = Locale.current
    }
    
    func formatDay(day: String?) -> String? {
        guard let day = day else  {
            return nil
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dayDate = dateFormatter.date(from: day) else {
            return nil
        }
        dateFormatter.dateFormat = "E dd.MM"
        return dateFormatter.string(for: dayDate)
    }
    
    func formatTime(time: String?) -> String? {
        guard let time = time else {
            return nil
        }
        dateFormatter.dateFormat = "HH:mm:ss"
        guard let timeDate = dateFormatter.date(from: time) else {
            return nil
        }
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: timeDate)
    }
}
