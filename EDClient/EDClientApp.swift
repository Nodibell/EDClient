//
//  EDClientApp.swift
//  EDClient
//
//  Created by Oleksii Chumak on 13.06.2024.
//

import SwiftUI

@main
struct EDClientApp: App {
    @StateObject private var addressInfo = FormAddress()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(addressInfo)
        }
    }
}
