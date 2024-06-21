//
//  HoursTableView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 19.06.2024.
//

import SwiftUI

struct HoursTableView: View {
    @Binding var isScheduleFetched: Bool
    @Binding var schedule: Schedule
    
    var body: some View {
        VStack {
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
                        ForEach(schedule.disconnections, id: \.time) { lightTime in
                            Text(SpecifiedDateFormat.shared.formatTime(time: lightTime.time) ?? NSLocalizedString("error", comment: ""))
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
                        ForEach(schedule.disconnections, id: \.time) { lightTime in
                            if let statusImage = lightTime.status?.image {
                                statusImage
                                    .frame(width: 160, height: 30)
                                    .padding(2)
                                    .foregroundStyle(electricityColor(status: lightTime.status ?? .possibleDisconnection))
                                    .background(electricityColor(status: lightTime.status ?? .possibleDisconnection).opacity(0.1))
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
        }.onAppear {
            print("Tables: ",schedule.disconnections.description)
            if schedule.disconnections.isEmpty && isScheduleFetched {
                fillScheduleWithUnknown()
            }
        }
    }
    
    
    private func fillScheduleWithUnknown() {
        for i in 0...23 {
            if i > 9 {
                schedule.disconnections.append(
                    LightTime(time: "\(i):00", status: .possibleDisconnection)
                )
            } else {
                schedule.disconnections.append(
                    LightTime(time: "0\(i):00", status: .possibleDisconnection)
                )
            }
        }
    }
    
    private func electricityColor(status: Status) -> Color {
        switch status {
        case .connected:
            return .green
        case .possibleDisconnection:
            return .orange
        case .disconnected:
            return .red
        }
    }
}

#Preview {
    HoursTableView(isScheduleFetched: .constant(true), schedule: .constant(
        Schedule(
            queueName: "Черга 4.1",
            date: "Пт 20.06",
            disconnections: [
                LightTime(time: "00:00", status: .connected),
                          LightTime(time: "01:00", status: .possibleDisconnection),
                          LightTime(time: "02:00", status: .disconnected)
            ]
        ))
    )
}
