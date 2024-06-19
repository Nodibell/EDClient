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
                    day: Date.now.description,
                    queue: "Черга відсутня",
                    cityName: "Місто відстунє",
                    streetName: "Вулиця відстуня",
                    buildingNumber: "Номер будівлі відстуній"
                )
            }
            HStack {
                Text("timeText")
                    .frame(width: 160, height: 30)
                    .padding(2)
                    .background(Color.orange)
                    .bold()
                    .border(Color.gray)
                Text("statusText")
                    .frame(width: 160, height: 30)
                    .padding(2)
                    .background(Color.orange)
                    .bold()
                    .border(Color.gray)
            }
            ScrollView(.vertical) {
                HStack {
                    VStack(spacing: 2) {
                        ForEach(schedule.Disconnections, id: \.Time) { lightTime in
                            Text(lightTime.Time)
                                .frame(width: 160, height: 30)
                                .padding(2)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 8,
                                        style: .continuous
                                    )
                                )
                            
                        }
                    }
                    
                    VStack(spacing: 2) {
                        ForEach(schedule.Disconnections, id: \.Time) { lightTime in
                            if let statusImage = lightTime.Status.image {
                                statusImage
                                    .frame(width: 160, height: 30)
                                    .padding(2)
                                    .foregroundColor(electricityColor(status: lightTime.Status))
                                    .background(electricityColor(status: lightTime.Status).opacity(0.1))
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 8,
                                            style: .continuous
                                        )
                                    )
                                    
                            }
                            
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            VStack {
                Section {
                    Label(
                        title: {
                            Text("noBlackouts")
                                .font(.caption2)
                                .monospaced()
                        },
                        icon: {
                            Status.connected.image.foregroundStyle(
                                electricityColor(status: Status.connected)
                            )
                        }
                    )
                    Label(
                        title: {
                            Text("possibleBlackouts")
                                .font(.caption2)
                                .monospaced()
                        },
                        icon: {
                            Status.posibleDisconnection.image.foregroundStyle(
                                electricityColor(status: Status.posibleDisconnection)
                            )
                        }
                    )
                    Label(
                        title: {
                            Text("blackouts")
                                .font(.caption2)
                                .monospaced()
                        },
                        icon: {
                            Status.disconnected.image.foregroundColor(
                                electricityColor(status: Status.disconnected)
                            )
                        }
                    )
                }
                .padding(1)
            }
            .shadow(color: .white.opacity(0.5), radius: 8)
            
                
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if schedule.isEmpty {
                fetchSchedule()
                isScheduleFetched.toggle()
            }
        }
        .padding()
    }
    
    private func fetchSchedule() {
        Task {
            do {
                let schedule = try await Client.shared.getSchedule(
                    cityID: addressInfo.cityID,
                    streetID: addressInfo.streetID,
                    buildingID: addressInfo.buildingID
                )
                self.schedule.Date = schedule.Date
                self.schedule.QueueName = schedule.QueueName
                self.schedule.Disconnections = schedule.Disconnections
                
                
            } catch {
                print("Error fetching schedule: \(error)")
                
            }
        }
    }

    private func electricityColor(status: Status) -> Color {
        switch status {
        case .connected:
            return .green
        case .posibleDisconnection:
            return .orange
        case .disconnected:
            return .red
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
    ), addressInfo: PinnedAddress(cityName: "місто Немирів", streetName: "вулиця Горького", buildingNumber: "50", cityID: 523010100, streetID: 13366, buildingID: 270424) as Address)
}
