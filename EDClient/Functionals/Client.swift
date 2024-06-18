//
//  Client.swift
//  EDClient
//
//  Created by Oleksii Chumak on 13.06.2024.
//

import Foundation

class Client {
    
    public static let shared = Client()
    
    private init () {}
    
    func getPrompts(for promptType: InformationType, id: Int = -1, search: String) async throws -> [Prompt] {
        guard let url = providePromptURL(for: promptType, id: id, search: search) else {
            return []
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let prompts = try JSONDecoder().decode([Prompt].self, from: data)
            return prompts
        } catch {
            return []
        }
    }
    
    private func providePromptURL(for promptType: InformationType, id: Int = -1, search: String) -> URL? {
        switch promptType {
        case .city:
            return URL(string: "http://lab.vntu.vn.ua/webusers/01-21-040/VPs/citiesFetch.php?value=\(search)")
        case .street:
            return URL(string: "http://lab.vntu.vn.ua/webusers/01-21-040/VPs/streetsFetch.php?code=\(id)&search=\(search)")
        case .building:
            return URL(string: "http://lab.vntu.vn.ua/webusers/01-21-040/VPs/buildingsFetch.php?id=\(id)&search=\(search)")
        }
    }
    
    func getSchedule(cityID: Int, streetID: Int, buildingID: Int) async throws -> Schedule {
        guard let url = provideScheduleURL(cityID: cityID, streetID: streetID, buildingID: buildingID) else {
            return Schedule()
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let jsonString = String(data: data, encoding: .utf8) else {
                return Schedule()
            }
        
            print("Received JSON String: \(jsonString)")
            
            let decoder = JSONDecoder()

            let jsonData = Data(jsonString.utf8)
            
            let schedule = try decoder.decode(Schedule.self, from: jsonData)
            return schedule
        } catch {
            print("Error fetching or decoding schedule: \(error)")
            return Schedule()
        }
    }

    
    private func provideScheduleURL(cityID: Int, streetID: Int, buildingID: Int) -> URL? {
        return URL(string: "http://lab.vntu.vn.ua/webusers/01-21-040/VPs//disconnection.php?cityId=\(cityID)&streetId=\(streetID)&buildingId=\(buildingID)")
    }
    
    func getPinnedAddresses() -> [PinnedAddress] {
        print("returned Pinned Addresses")
        return [
            PinnedAddress(cityName: "місто Вінниця", streetName: "вулиця Соборна", buildingNumber: "21", cityID: 0, streetID: 0, buildingID: 0),
            PinnedAddress(cityName: "місто Вінниця", streetName: "вулиця Магістрацька", buildingNumber: "12", cityID: 1, streetID: 1, buildingID: 1),
            PinnedAddress(cityName: "місто Немирів (Немирівський Район/М.Немирів)", streetName: "вулиця Горького", buildingNumber: "50", cityID: 523010100, streetID: 13366, buildingID: 270425)
        ]
    }
}

