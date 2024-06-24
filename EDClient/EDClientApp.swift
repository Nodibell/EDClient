//
//  EDClientApp.swift
//  EDClient
//
//  Created by Oleksii Chumak on 13.06.2024.
//

import SwiftUI
import SwiftData

@main
struct EDClientApp: App {
    @StateObject private var addressInfo = FormAddress()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PinnedAddress.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(addressInfo)
        }
        .modelContainer(sharedModelContainer)
    }
}
