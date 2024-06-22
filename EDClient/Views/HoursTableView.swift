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
                    .foregroundStyle(.white)
                    .padding(2)
                    .background(Color.orange)
                    .bold()
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 8,
                            style: .continuous
                        )
                    )
                    .padding(2)
                    .background(Color.accentColor)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 8,
                            style: .continuous
                        )
                    )
                Text("statusText")
                    .frame(width: 160, height: 30)
                    .foregroundStyle(.white)
                    .padding(2)
                    .background(Color.orange)
                    .bold()
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 8,
                            style: .continuous
                        )
                    )
                    .padding(2)
                    .background(Color.accentColor)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 8,
                            style: .continuous
                        )
                    )
            }
            ScrollView(.vertical) {
                HStack {
                    VStack(spacing: 2) {
                        ForEach(schedule.disconnections, id: \.time) { lightTime in
                            Text(SpecifiedDateFormat.shared.formatTime(time: lightTime.time) ?? NSLocalizedString("error", comment: ""))
                                .frame(width: 160, height: 30)
                                .padding(2)
                                .background(colorHours(
                                    time: SpecifiedDateFormat.shared.toTimeDate(from: lightTime.time))
                                )
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
            .defaultScrollAnchor(defaultScrollPoint())
        }
    }
    
    
    private func defaultScrollPoint() -> UnitPoint? {
        let hour = SpecifiedDateFormat.shared.calendar.component(.hour, from: SpecifiedDateFormat.shared.now)
        
        switch hour.self {
        case 0..<6:
            return .top
        case 6..<12:
            return UnitPoint(
                x: (UnitPoint.top.x + UnitPoint.center.x).remainder(dividingBy: 2),
                y: (UnitPoint.top.y + UnitPoint.center.y).remainder(dividingBy: 2)
            )
        case 12..<18:
            return .center
        case 18..<21:
            return UnitPoint(
                x: (UnitPoint.center.x + UnitPoint.bottom.x).remainder(dividingBy: 2),
                y: (UnitPoint.center.y + UnitPoint.bottom.y).remainder(dividingBy: 2)
            )
        case 21..<24:
            return .bottom
        default:
            return nil
        }
    }
    
    private func colorHours(time: Date?) -> Color {
        guard let time = time else {
            return Color.gray.opacity(0.1)
        }
        
        if SpecifiedDateFormat.shared.isAfterNow(time: time) ?? false {
            return Color.indigo.opacity(0.08)
        } else if SpecifiedDateFormat.shared.isNow(time: time) ?? false {
            return Color.indigo.opacity(0.5)
        } else {
            return Color.gray.opacity(0.1)
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
