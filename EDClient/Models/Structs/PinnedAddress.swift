//
//  PinnedAddress.swift
//  EDClient
//
//  Created by Oleksii Chumak on 16.06.2024.
//

import Foundation

struct PinnedAddress: Address, Hashable {
    var description: String {
        "(Id: \(cityID) CityName: \(cityName)), (Id: \(streetID) StreetName: \(streetName)), (Id: \(buildingID) StreetName: \(buildingNumber))"
    }
    
    let cityName: String
    let streetName: String
    let buildingNumber: String
    let cityID: Int
    let streetID: Int
    let buildingID: Int
}
