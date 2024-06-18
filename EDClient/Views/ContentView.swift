//
//  ContentView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 13.06.2024.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var addressInfo: FormAddress
    let internetChecker = InternetChecker.shared.checkConnectivity()
    
    var body: some View {
        MainView()
    }
    
}

#Preview {
    ContentView()
}
