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
            return URL(string: "http://lab.vntu.vn.ua/webusers/01-21-040/VPs/citiesFetch.php?value=\(search)")
            //return URL(string: "http://localhost:5062/api/Address/City?query=\(search)")
        case .street:
            return URL(string: "http://lab.vntu.vn.ua/webusers/01-21-040/VPs/streetsFetch.php?code=\(id)&search=\(search)")
            //return URL(string: "http://localhost:5062/api/Address/Street?cityId=\(id)&nameOfStreet=\(search)")
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
        //return URL(string: "http://localhost:5062/api/Disconnections?cityId=\(cityID)&streetId=\(streetID)&houseId=\(buildingID)")
    }
    
    func getPinnedAddresses() async throws -> [PinnedAddress] {
        /*
        guard let uuid = await UIDevice.current.identifierForVendor?.uuidString else {
            return []
        }
        guard let url = providePinnedAddressesURL(uiid: uuid) else {
            return []
        }
        do {
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(url)
                    .responseData { response in
                        switch response.result {
                        case let .success(data):
                            do {
                                let pinnedAddresses = try JSONDecoder().decode([PinnedAddress].self, from: data)
                                continuation.resume(returning: pinnedAddresses)
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
            return []
        }
        */
        return []
    }
    
    func postPinnedAddress(addressInfo: PinnedAddress) async {
        guard let uuid = await UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        print(uuid.description, addressInfo.description)
    }
    
    func isPinnedAddress(addressInfo: PinnedAddress) async -> Bool? {
        do {
            let pinnedAddresses = try await getPinnedAddresses()
            if !pinnedAddresses.isEmpty {
                return pinnedAddresses.contains { pinnedAddress in
                    pinnedAddress == addressInfo
                }
            } else {
                return nil
            }
        } catch {
            print("Failled to get info about pinned address")
            return nil
        }
    }
    

    
    private func providePinnedAddressesURL(uiid: String) -> URL? {
        return URL(string: "http://localhost:5062/api/PinnedAddresses?DeviceID=\(uiid)")
    }
}

