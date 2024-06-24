//
//  ScheduleView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 15.06.2024.
//

import SwiftUI
import SwiftData

struct ScheduleView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var pinnedAddresses: [PinnedAddress]
    
    @State var schedule: Schedule = Schedule()
    @State var isScheduleFetched = false
    @State var addressInfo: Address
    @State private var isLoading: Bool = true
    @State private var isPinned: Bool?
    
    var body: some View {
        VStack {
            if !InternetChecker.shared.checkConnectivity() {
                ContentUnavailableView("connectionErrorTitle", systemImage: "wifi.slash", description: Text("connectionErrorDescription"))
            } else {
                if isScheduleFetched && !schedule.isEmpty {
                    AddressInfoView(
                        date: SpecifiedDateFormat.shared.formatDay(day: schedule.date) ?? SpecifiedDateFormat.shared.todayDate,
                        queueName: schedule.queueName ?? NSLocalizedString("noQueueScheduleView", comment: ""),
                        cityName: addressInfo.cityName,
                        streetName: addressInfo.streetName,
                        buildingNumber: addressInfo.buildingNumber
                    )
                } else {
                    AddressInfoView(
                        date: SpecifiedDateFormat.shared.todayDate,
                        queueName: NSLocalizedString("noQueueScheduleView", comment: ""),
                        cityName: "",
                        streetName: "",
                        buildingNumber: "",
                        noAddressInfo: NSLocalizedString("noAddressInfoView", comment: "")
                    )
                }
                
                HoursTableView(isScheduleFetched: $isScheduleFetched, schedule: $schedule)
                
                VStack {
                    Section {
                        Label(
                            title: {
                                Text("noBlackouts")
                                    .font(.caption2)
                                    .monospaced()
                            },
                            icon: {
                                Status.connected.image.foregroundStyle(.green)
                            }
                        )
                        Label(
                            title: {
                                Text("possibleBlackouts")
                                    .font(.caption2)
                                    .monospaced()
                            },
                            icon: {
                                Status.possibleDisconnection.image.foregroundStyle(.orange)
                            }
                        )
                        Label(
                            title: {
                                Text("blackouts")
                                    .font(.caption2)
                                    .monospaced()
                            },
                            icon: {
                                Status.disconnected.image?.foregroundStyle(.red)
                            }
                        )
                    }
                    .padding(1)
                }
                .shadow(color: .white.opacity(0.5), radius: 8)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let isPinned = isPinned {
                    Button(action: {
                            if isPinned {
                                unpinAddress()
                            } else {
                                pinAddress()
                            }
                        self.isPinned = checkIfPinned()
                    }) {
                        Label("Pin Address", systemImage: isPinned ? "pin.slash.fill" : "pin.fill").animation(.easeInOut, value: isPinned)
                    }
                }
            }
        }
        .opacity(isLoading ? 0 : 1)
        .overlay {
            if isLoading {
                ProgressView {
                    Text("loading")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .progressViewStyle(.circular)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isPinned = checkIfPinned()
            fetchSchedule()
        }
        .padding()
    }
    
    private func fetchSchedule() {
        Task {
            do {
                isLoading = true
                isScheduleFetched = false
                let schedule = try await Client.shared.getSchedule(
                    cityID: addressInfo.cityID,
                    streetID: addressInfo.streetID,
                    buildingID: addressInfo.buildingID
                )
                self.schedule.date = schedule.date
                self.schedule.queueName = schedule.queueName
                self.schedule.disconnections = schedule.disconnections
                isLoading = false
                isScheduleFetched = true
            } catch {
                print("Error fetching schedule: \(error)")
                isLoading = true
            }
        }
    }
    
    private func pinAddress() {
        guard let isPinned = isPinned else {
            return
        }
        if !isPinned {
            if addressInfo is FormAddress {
                modelContext.insert(PinnedAddress(formAddress: addressInfo as! FormAddress))
            } else if addressInfo is PinnedAddress {
                modelContext.insert(addressInfo as! PinnedAddress)
            }
        }
    }
    
    private func unpinAddress() {
        withAnimation {
            if addressInfo is FormAddress {
                modelContext.delete(PinnedAddress(formAddress: addressInfo as! FormAddress))
            } else if addressInfo is PinnedAddress {
                modelContext.delete(addressInfo as! PinnedAddress)
            }
        }
    }
    
    private func checkIfPinned() -> Bool {
        return pinnedAddresses.contains { pinnedAddress in
            if addressInfo is PinnedAddress {
                return pinnedAddress == addressInfo as! PinnedAddress
            } else if addressInfo is FormAddress {
                return pinnedAddress == PinnedAddress(formAddress: addressInfo as! FormAddress)
            }
            return false
        }
    }
}

#Preview {
    ScheduleView(schedule: Schedule(
        queueName: "Черга 4.1",
        date: "Пт 20.06",
        disconnections: [
            LightTime(time: "00:00", status: .connected),
            LightTime(time: "01:00", status: .possibleDisconnection),
            LightTime(time: "02:00", status: .disconnected)
        ]
    ), addressInfo: PinnedAddress(cityName: "м. Немирів", streetName: "вулиця Горького", buildingNumber: "50", cityID: 523010100, streetID: 13366, buildingID: 270424) as Address)
}
