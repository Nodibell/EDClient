//
//  SpecifiedDateFormat.swift
//  EDClient
//
//  Created by Oleksii Chumak on 20.06.2024.
//

import Foundation

class SpecifiedDateFormat {
    static let shared = SpecifiedDateFormat()
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    
    var now: Date {
        Date()
    }
    
    var todayDate: String {
        dateFormatter.dateFormat = "E dd.MM"
        return dateFormatter.string(for: now)!
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
    
    func toTimeDate(from stringTime: String?) -> Date? {
        guard let stringTime = stringTime else  {
            return nil
        }
        dateFormatter.dateFormat = "HH:mm"
        guard let time = dateFormatter.date(from: stringTime) else {
            return nil
        }
        return time
    }
    
    func toDayDate(from stringDay: String?) -> Date? {
        guard let stringDay = stringDay else  {
            return nil
        }
        dateFormatter.dateFormat = "E dd.MM"
        guard let day = dateFormatter.date(from: stringDay) else {
            return nil
        }
        return day
    }
    
    func formatTime(time: String?) -> String? {
        guard let time = time else {
            return nil
        }
        dateFormatter.dateFormat = "HH:mm"
        guard let timeDate = dateFormatter.date(from: time) else {
            return nil
        }
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: timeDate)
    }
    
    func isNow(time: Date?) -> Bool? {
        dateFormatter.dateFormat = "HH:mm"
        guard let time = time else {
            print("no data now")
            return nil
        }
        
        let nowComponents = calendar.dateComponents([.hour], from: now)
        let timeComponents = calendar.dateComponents([.hour], from: time)
        return nowComponents.hour?.description == timeComponents.hour?.description
            
    }
    
    func isBeforeNow(time: Date?) -> Bool? {
        dateFormatter.dateFormat = "HH:mm"
        guard let time = time else {
            return nil
        }
        let nowComponents = calendar.dateComponents([.hour], from: now)
        let timeComponents = calendar.dateComponents([.hour], from: time)
        if let nowHours = nowComponents.hour,
           let timeHours = timeComponents.hour {
            return nowHours > timeHours
        }
        return nil
    }
    
    func isAfterNow(time: Date?) -> Bool? {
        dateFormatter.dateFormat = "HH:mm"
        guard let time = time else {
            return nil
        }
        let nowComponents = calendar.dateComponents([.hour], from: now)
        let timeComponents = calendar.dateComponents([.hour], from: time)
        
        if let nowHours = nowComponents.hour,
           let timeHours = timeComponents.hour {
            return nowHours > timeHours
        }
        return nil
    }
}

