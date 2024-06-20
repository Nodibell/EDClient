//
//  PinnedAddress.swift
//  EDClient
//
//  Created by Oleksii Chumak on 16.06.2024.
//

import Foundation

struct PinnedAddress: Address, Hashable, Decodable, Equatable {
    var description: String {
        "(Id: \(cityID) CityName: \(cityName)), (Id: \(streetID) StreetName: \(streetName)), (Id: \(buildingID) StreetName: \(buildingNumber))"
    }
    
    let cityName: String
    let streetName: String
    let buildingNumber: String
    let cityID: Int
    let streetID: Int
    let buildingID: Int
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.cityName == rhs.cityName &&
        lhs.streetName == rhs.streetName &&
        lhs.buildingNumber == rhs.buildingNumber &&
        lhs.cityID == rhs.cityID &&
        lhs.streetID == rhs.streetID &&
        lhs.buildingID == rhs.buildingID
    }
    
    init(cityName: String, streetName: String, buildingNumber: String, cityID: Int, streetID: Int, buildingID: Int) {
        self.cityName = cityName
        self.streetName = streetName
        self.buildingNumber = buildingNumber
        self.cityID = cityID
        self.streetID = streetID
        self.buildingID = buildingID
    }
    
    init(formAddress: FormAddress) {
        self.cityName = formAddress.cityName
        self.streetName = formAddress.streetName
        self.buildingNumber = formAddress.buildingNumber
        self.cityID = formAddress.cityID
        self.streetID = formAddress.streetID
        self.buildingID = formAddress.buildingID
    }
}
