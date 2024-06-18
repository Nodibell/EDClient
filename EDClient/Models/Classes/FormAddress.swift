//
//  Address.swift
//  EDClient
//
//  Created by Oleksii Chumak on 13.06.2024.
//

import Foundation

final class FormAddress: Address, ObservableObject {
    var description: String {
        "(Id: \(cityID) CityName: \(cityName)), (Id: \(streetID) StreetName: \(streetName)), (Id: \(buildingID) StreetName: \(buildingNumber))"
    }
    
    @Published var cityName: String
    @Published var streetName: String
    @Published var buildingNumber: String
    @Published var cityID: Int
    @Published var streetID: Int
    @Published var buildingID: Int
    
    
    init(cityName: String, streetName: String, buildingNumber: String, cityID: Int, streetID: Int, buildingID: Int) {
        self.cityName = cityName
        self.streetName = streetName
        self.buildingNumber = buildingNumber
        self.cityID = cityID
        self.streetID = streetID
        self.buildingID = buildingID
    }
    
    init() {
        self.cityName = ""
        self.streetName = ""
        self.buildingNumber = ""
        self.cityID = -1
        self.streetID = -1
        self.buildingID = -1
    }
    
    init(pinnedAddress: PinnedAddress) {
        self.cityName = pinnedAddress.cityName
        self.streetName = pinnedAddress.streetName
        self.buildingNumber = pinnedAddress.streetName
        self.cityID = pinnedAddress.cityID
        self.streetID = pinnedAddress.streetID
        self.buildingID = pinnedAddress.buildingID
    }
    
    func makeEmpty() {
        self.cityName = ""
        self.streetName = ""
        self.buildingNumber = ""
        self.cityID = -1
        self.streetID = -1
        self.buildingID = -1
    }
    
    func changeInfo(of type: InformationType, id: Int, value: String) {
        switch type {
        case .city:
            cityID = id
            cityName = value
            streetID = -1
            buildingID = -1
            streetName = ""
            buildingNumber = ""
        case .street:
            streetID = id
            streetName = value
            buildingID = -1
            buildingNumber = ""
        case .building:
            buildingID = id
            buildingNumber = value
        }
    }
}
