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
                                // needs realization through the client and server
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
                        .bold()
                        .padding()
                        .foregroundStyle(.white)
                        .background(TimelineView(.animation) { timeline in
                            let now = timeline.date.timeIntervalSinceReferenceDate
                            let angle = Angle.degrees(now.truncatingRemainder(dividingBy: 20) * 18)
                            AngularGradient(
                                gradient: Gradient(colors: [.orange, .pink, .indigo, .purple, .orange.opacity(3)]),
                                center: .center,
                                startAngle: .degrees(angle.degrees),
                                endAngle: .degrees(angle.degrees + 360)
                            )
                            .blur(radius: 4, opaque: false)
                        })
                        .clipShape(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                        )
                        .padding()
                }
            }
            .sheet(isPresented: $isShowingForm) {
                VStack {
                    Image(systemName: "chevron.compact.down")
                        .resizable()
                        .symbolEffect(.scale)
                        .frame(width: 36, height: 12)
                        .foregroundStyle(Gradient(colors: [.indigo, .purple]))
                        .padding(EdgeInsets(top: 18, leading: 1, bottom: 0, trailing: 1))
                    AddressChoosingView()
                }.background(Color(.secondarySystemBackground))
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
