//
//  Prompt.swift
//  EDClient
//
//  Created by Oleksii Chumak on 13.06.2024.
//

import Foundation

struct Prompt: Decodable, Identifiable, CustomStringConvertible {
    var description: String {
        "(id: \(id), value: \(value))"
    }
    let id: Int
    let value: String
}
