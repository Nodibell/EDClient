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
    @State private var rotation: Double = 0
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
                        }.listStyle(.inset)
                        
                        
                    } else {
                        ContentUnavailableView.init("Connection Error", systemImage: "wifi.slash", description: Text("Failed to connect to the network"))
                    }
                }
                .navigationTitle("pinnedAddressesTitle")
            
            
            
            
                Button(action: {
                    isShowingForm.toggle()
                }) {
                    Text("getScheduleText")
                        .font(.title2)
                        .padding()
                        .foregroundStyle(.white)
                        .background(
                            AngularGradient(
                                gradient: Gradient(colors:
                                                    [.orange, .pink, .indigo, .purple, .orange.opacity(3)]
                                                  ),
                                center: .center,
                                startAngle: .degrees(rotation),
                                endAngle: .degrees(rotation + 360)
                            ).blur(radius: 4, opaque: false)
                                .animation(Animation.linear(duration: 20).repeatForever(autoreverses: false), value: rotation)
                        )
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
