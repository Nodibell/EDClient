//
//  MainView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 16.06.2024.
//

import SwiftUI

struct MainView: View {
    @State private var isShowingForm = false
    @State private var pinnedAddresses: [PinnedAddress] = []
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack {
                    if InternetChecker.shared.checkConnectivity() {
                        List {
                            ForEach(pinnedAddresses, id: \.self) { pinnedAddress in
                                NavigationLink {
                                    ScheduleView(addressInfo: pinnedAddress as Address)
                                } label: {
                                    PinnedAddressItemView(pinnedAddress: pinnedAddress)
                                }
                            }
                            .onDelete { offset in
                                pinnedAddresses.remove(atOffsets: offset)
                            }
                        }.listStyle(.grouped)
                        
                        
                    } else {
                        ContentUnavailableView.init("Connection Error", systemImage: "wifi.slash", description: Text("Failed to connect to the network"))
                    }
                }
                .navigationTitle("pinnedAddressesTitle")
            }
            
            
            VStack {
                Button(action: {
                    isShowingForm.toggle()
                }) {
                    Text("getScheduleText")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .sheet(isPresented: $isShowingForm) {
                AddressChoosingView()
            }
            .onAppear {
                fetchPinnedAddresses()
            }
        }
    }
    
    private func fetchPinnedAddresses() {
        Task {
            do {
                let pinnedAddresses = try await Client.shared.getPinnedAddresses()
                self.pinnedAddresses = pinnedAddresses
            } catch {
                print("Error fetching schedule: \(error)")
                self.pinnedAddresses = []
            }
        }
    }
}

#Preview {
    MainView()
}
