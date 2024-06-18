//
//  Building.swift
//  EDClient
//
//  Created by Oleksii Chumak on 15.06.2024.
//

import Foundation

struct Building: Prompt {
    var description: String {
        "(id: \(id), value: \(value))"
    }
    
    let id: Int
    let value: String

}
