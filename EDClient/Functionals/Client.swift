//
//  Client.swift
//  EDClient
//
//  Created by Oleksii Chumak on 13.06.2024.
//

import Foundation
import Alamofire
import UIKit

class Client {
    
    public static let shared = Client()
    
    private init () {}
    
    func getPrompts<T: Prompt>(for promptType: InformationType, id: Int = -1, search: String) async throws -> [T] {
        guard let url = providePromptURL(for: promptType, id: id, search: search) else {
            return []
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .responseData { response in
                    switch response.result {
                    case let .success(data):
                        do {
                            let prompts = try JSONDecoder().decode([T].self, from: data)
                            continuation.resume(returning: prompts)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
            }
        }
    }

    
    private func providePromptURL(for promptType: InformationType, id: Int = -1, search: String) -> URL? {
        switch promptType {
        case .city:
            //return URL(string: "http://lab.vntu.vn.ua/webusers/01-21-040/VPs/citiesFetch.php?value=\(search)")
            return URL(string: "http://localhost:5062/api/Address/City?query=\(search)")
        case .street:
            //return URL(string: "http://lab.vntu.vn.ua/webusers/01-21-040/VPs/streetsFetch.php?code=\(id)&search=\(search)")
            return URL(string: "http://localhost:5062/api/Address/Street?cityId=\(id)&nameOfStreet=\(search)")
        case .building:
            return URL(string: "http://lab.vntu.vn.ua/webusers/01-21-040/VPs/buildingsFetch.php?id=\(id)&search=\(search)")
            //return URL(string: "http://localhost:5062/api/Address/HouseNumber?streetId=\(id)&numberOfBuild=\(search)")
        }
    }
    
    func getSchedule(cityID: Int, streetID: Int, buildingID: Int) async throws -> Schedule {
        guard let url = provideScheduleURL(cityID: cityID, streetID: streetID, buildingID: buildingID) else {
            return Schedule()
        }
        
        do {
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(url)
                    .responseData { response in
                        switch response.result {
                        case let .success(data):
                            do {
                                let schedule = try JSONDecoder().decode(Schedule.self, from: data)
                                continuation.resume(returning: schedule)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        case let .failure(error):
                            continuation.resume(throwing: error)
                        }
                    }
            }
        } catch {
            print("Error fetching or decoding schedule: \(error)")
            return Schedule()
        }
    }
    
    
    private func provideScheduleURL(cityID: Int, streetID: Int, buildingID: Int) -> URL? {
        return URL(string: "http://lab.vntu.vn.ua/webusers/01-21-040/VPs//disconnection.php?cityId=\(cityID)&streetId=\(streetID)&buildingId=\(buildingID)")
        //return URL(string: "http://localhost:5062/api/Disconnections?cityId=\(cityID)&streetId=\(streetID)&numberOfHouseId=\(buildingID)")
    }
    
    
    
    func getPinnedAddresses() -> [PinnedAddress] {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            providePinnedAddressesURL(id: uuid)
        }
        print("returned Pinned Addresses")
        return [
            PinnedAddress(cityName: "місто Вінниця", streetName: "вулиця Соборна", buildingNumber: "21", cityID: 0, streetID: 0, buildingID: 0),
            PinnedAddress(cityName: "місто Вінниця", streetName: "вулиця Магістрацька", buildingNumber: "12", cityID: 1, streetID: 1, buildingID: 1),
            PinnedAddress(cityName: "місто Немирів (Немирівський Район/М.Немирів)", streetName: "вулиця Горького", buildingNumber: "50", cityID: 523010100, streetID: 13366, buildingID: 270425)
        ]
    }
    
    private func providePinnedAddressesURL(id: String) /*-> URL?*/ {
        print("Recieved \(id)")
    }
}

