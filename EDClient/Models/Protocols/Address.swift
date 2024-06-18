//
//  Address.swift
//  EDClient
//
//  Created by Oleksii Chumak on 16.06.2024.
//

import Foundation

protocol Address: CustomStringConvertible {
    var cityName: String { get }
    var streetName: String { get }
    var buildingNumber: String { get }
    var cityID: Int { get }
    var streetID: Int { get }
    var buildingID: Int { get }
}
