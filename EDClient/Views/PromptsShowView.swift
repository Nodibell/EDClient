//
//  PromptsShowView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 13.06.2024.
//

import SwiftUI

import SwiftUI

struct PromptsShowView: View {
    var promptType: InformationType
    let neededSymbolsCount = 2
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var addressInfo: FormAddress
    @State private var searchText: String = ""
    @State private var prompts: [any Prompt] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            if InternetChecker.shared.checkConnectivity() {
                List {
                    ForEach(prompts, id: \.id) { prompt in
                        HStack {
                            Text(prompt.value)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            addressInfo.changeInfo(
                                of: promptType,
                                id: prompt.id,
                                value: prompt.value
                            )
                            dismiss()
                        }
                    }
                }
                .searchable(text: $searchText)
                .listStyle(.inset)
                .navigationTitle(promptType.localizedName)
                .onChange(of: searchText) { oldValue, newValue in
                    handleSearchTextChange(oldValue: oldValue, newValue: newValue)
                }
                .overlay {
                    contentUnvailableOverlay
                }
            } else {
                ContentUnavailableView("Connection Error", systemImage: "wifi.slash", description: Text("Failed to connect to the network"))
            }
        }
    }
    
    private var contentUnvailableOverlay: some View {
        Group {
            if isLoading {
                ProgressView {
                    Text("loading")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .progressViewStyle(.circular)
            } else if prompts.isEmpty {
                if promptType != .building && searchText.count <= neededSymbolsCount {
                    ContentUnavailableView(
                        LocalizedStringKey("3symbolsNeededPromptsShowView"),
                        systemImage: "magnifyingglass",
                        description: Text(
                            LocalizedStringKey("3symbolsNeededDescriptionPromptsShowView"))
                    )
                } else if promptType == .building && searchText.count == 0 {
                    ContentUnavailableView(
                        LocalizedStringKey("startInputBuilding"),
                        systemImage: "magnifyingglass",
                        description: Text("inputBuildingDescription")
                    )
                } else {
                    ContentUnavailableView.search
                }
            }
        }
    }
    
    private func handleSearchTextChange(oldValue: String, newValue: String) {
        if oldValue != newValue && !newValue.isEmpty && (newValue.count > neededSymbolsCount || promptType == .building) {
            prompts = []
            fetchPrompts()
        } else if newValue.count <= neededSymbolsCount {
            prompts = []
        }
    }
    
    private func fetchPrompts() {
        Task {
            isLoading = true
            do {
                switch promptType {
                case .city:
                    prompts = try await Client.shared.getPrompts(for: promptType, search: searchText) as [City]
                case .street:
                    prompts = try await Client.shared.getPrompts(for: promptType, id: addressInfo.cityID, search: searchText) as [Street]
                case .building:
                    prompts = try await Client.shared.getPrompts(for: promptType, id: addressInfo.streetID, search: searchText) as [Building]
                }
            } catch {
                print("Error fetching prompts: \(error)")
            }
            isLoading = false
        }
    }
}



#Preview {
    PromptsShowView(promptType: .city)
}
