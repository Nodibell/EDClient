//
//  Prompt.swift
//  EDClient
//
//  Created by Oleksii Chumak on 13.06.2024.
//

import Foundation

protocol Prompt: Decodable, Identifiable, CustomStringConvertible {
    var id: Int { get }
    var value: String { get }
}
