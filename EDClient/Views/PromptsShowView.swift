//
//  PromptsShowView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 13.06.2024.
//

import SwiftUI

struct PromptsShowView: View {
    var promptType : InformationType
    let neededSymbolsCount = 2
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var addressInfo: FormAddress
    @State var searchText: String = ""
    @State var prompts: [any Prompt] = []
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack {
            if isNetworkConnected() {
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
                    if oldValue != newValue && !newValue.isEmpty && (newValue.count > neededSymbolsCount || promptType == .building) {
                        prompts = []
                        fetchPrompts()
                    } else if newValue.count <= neededSymbolsCount {
                        prompts = []
                    }
                }
                .overlay {
                    if isLoading {
                        ProgressView {
                            Text("loading")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .progressViewStyle(.circular)
                    } else if prompts.isEmpty && (searchText.count <= neededSymbolsCount || promptType == .building) {
                        if promptType != .building && searchText.count <= neededSymbolsCount {
                            ContentUnavailableView(
                                LocalizedStringKey("3symbolsNeeded"),
                                systemImage: "magnifyingglass",
                                description: Text(
                                    LocalizedStringKey("3symbolsNeededDescription"))
                            )
                        } else {
                            ContentUnavailableView(
                                LocalizedStringKey("startInputBuilding"),
                                systemImage: "magnifyingglass",
                                description: Text("inputBuildingDescription")
                            )
                        }
                    } else if prompts.isEmpty && !isLoading {
                        ContentUnavailableView.search
                    }
                }

            } else {
                ContentUnavailableView.init("Connection Error", systemImage: "wifi.slash", description: Text("Failed to connect to the network"))
            }
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
    
    private func isNetworkConnected() -> Bool {
        return InternetChecker.shared.checkConnectivity()
    }
}


#Preview {
    PromptsShowView(promptType: .city, searchText: "Нем")
}
