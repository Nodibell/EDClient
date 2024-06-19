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

    var body: some View {
        VStack {
            if isScheduleFetched {
                AddressInfoView(
                    day: schedule.Date,
                    queue: schedule.QueueName ?? "Черга відсутня",
                    cityName: addressInfo.cityName,
                    streetName: addressInfo.streetName,
                    buildingNumber: addressInfo.buildingNumber
                )
            } else {
                AddressInfoView(
                    day: Date.now.formatted(date: .abbreviated, time: .shortened),
                    queue: "Черга відсутня",
                    cityName: "Місто відстунє",
                    streetName: "Вулиця відстуня",
                    buildingNumber: "Номер будівлі відстуній"
                )
            }
            
            HoursTableView(schedule: schedule)
            
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
            if schedule.isEmpty {
                fetchSchedule()
            }
        }
        .padding()
    }
    
    private func fetchSchedule() {
        Task {
            do {
                isLoading = true
                let schedule = try await Client.shared.getSchedule(
                    cityID: addressInfo.cityID,
                    streetID: addressInfo.streetID,
                    buildingID: addressInfo.buildingID
                )
                self.schedule.Date = schedule.Date
                self.schedule.QueueName = schedule.QueueName
                self.schedule.Disconnections = schedule.Disconnections
                isLoading = false
                isScheduleFetched = true
            } catch {
                print("Error fetching schedule: \(error)")
                isLoading = true
            }
        }
    }

}

#Preview {
    ScheduleView(schedule: Schedule(
        QueueName: "Черга 4.1",
        Date: "Пт 20.06",
        Disconnections: [
            LightTime(time: "00:00", status: Status(rawValue: 2) ?? .connected),
            LightTime(time: "01:00", status: Status(rawValue: 1) ?? .connected),
            LightTime(time: "02:00", status: Status(rawValue: 0) ?? .connected)
        ]
    ), addressInfo: PinnedAddress(cityName: "м. Немирів", streetName: "вулиця Горького", buildingNumber: "50", cityID: 523010100, streetID: 13366, buildingID: 270424) as Address)
}
