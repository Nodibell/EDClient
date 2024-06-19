//
//  HoursTableView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 19.06.2024.
//

import SwiftUI

struct HoursTableView: View {
    var schedule: Schedule
    
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
    HoursTableView(schedule: Schedule(
        QueueName: "Черга 4.1",
        Date: "Пт 20.06",
        Disconnections: [
            LightTime(time: "00:00", status: Status(rawValue: 2) ?? .connected),
            LightTime(time: "01:00", status: Status(rawValue: 1) ?? .connected),
            LightTime(time: "02:00", status: Status(rawValue: 0) ?? .connected)
        ]
    ))
}
