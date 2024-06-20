//
//  ScheduleView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 15.06.2024.
//

import SwiftUI

struct ScheduleView: View {
    @State var schedule: Schedule = Schedule()
    @State var isScheduleFetched = false
    @State var addressInfo: Address
    @State private var isLoading: Bool = true
    @State private var isPinned: Bool?
    
    var body: some View {
        VStack {
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
                            Status.posibleDisconnection.image.foregroundStyle(.orange)
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let isPinned = isPinned {
                    Button(action: {
                        Task {
                            if isPinned {
                                await unpinAddress()
                            } else {
                                await pinAddress()
                            }
                        }
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
            checkIfPinned()
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
    
    private func pinAddress() async {
        guard let isPinned = isPinned else {
            return
        }
        if !isPinned {
            //await Client.shared.postPinnedAddress(addressInfo: addressInfo as! PinnedAddress)
        }
        
        print("Address Pinned")
    }
    
    private func unpinAddress() async {
        
    }
    
    private func checkIfPinned() {
        Task {
            isPinned = await Client.shared.isPinnedAddress(
                addressInfo: addressInfo.self is FormAddress
                ? PinnedAddress(formAddress: addressInfo as! FormAddress)
                : addressInfo as! PinnedAddress
            )
        }
    }
}

#Preview {
    ScheduleView(schedule: Schedule(
        queueName: "Черга 4.1",
        date: "Пт 20.06",
        disconnections: [
            LightTime(time: "00:00", status: Status(rawValue: 2) ?? .connected),
            LightTime(time: "01:00", status: Status(rawValue: 1) ?? .connected),
            LightTime(time: "02:00", status: Status(rawValue: 0) ?? .connected)
        ]
    ), addressInfo: PinnedAddress(cityName: "м. Немирів", streetName: "вулиця Горького", buildingNumber: "50", cityID: 523010100, streetID: 13366, buildingID: 270424) as Address)
}
