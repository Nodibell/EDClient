//
//  AddressInfoView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 15.06.2024.
//

import SwiftUI

struct AddressInfoView: View {
    var date: String
    var queueName: String
    var cityName: String
    var streetName: String
    var buildingNumber: String
    var noAddressInfo: String = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .center, spacing: 8) {
                Text(date.capitalized(with: .current))
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .background(
                        TimelineView(.animation) { timeline in
                            let now = timeline.date.timeIntervalSinceReferenceDate
                            let angle = Angle.degrees(now.truncatingRemainder(dividingBy: 20) * 18)
                            AngularGradient(
                                gradient: Gradient(colors: [.orange, .pink, .indigo, .purple, .orange.opacity(3)]),
                                center: .center,
                                startAngle: .degrees(angle.degrees),
                                endAngle: .degrees(angle.degrees + 360)
                            )
                            .blur(radius: 4, opaque: false)
                        }
                    )
                    .clipShape(RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    ))
                    .padding(4)
                    .background(Color.orange.grayscale(0.2))
                    .clipShape(RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    ))
                    .shadow(color: .white.opacity(0.5), radius: 8)
                
                
                Text(queueName)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.orange.grayscale(0.2))
                    .clipShape(RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    ))
                    .shadow(color: .white.opacity(0.5), radius: 8)
                    .padding(6)
                
                Text(!(cityName.isEmpty && streetName.isEmpty && buildingNumber.isEmpty) ? "\(cityName), \(streetName) \(buildingNumber)" : "\(noAddressInfo)")
                    .font(.caption)
                    .lineLimit(10)
                    .padding(.horizontal, 8)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .italic()
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(Color.orange.grayscale(0.2))
                    .clipShape(RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    ))
                    .shadow(color: .white.opacity(0.53), radius: 8)
                
            }
            .padding()
        }
        .background(
            LinearGradient(colors: [.orange.opacity(3), .pink.opacity(2), .indigo.opacity(3)], startPoint: .bottomTrailing, endPoint: .topLeading)
            .grayscale(0.25)
        )
        
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
        .shadow(color: .white.opacity(0.4), radius: 8)
        .padding()
    }
}

#Preview {
    AddressInfoView(date: "Пт 21.06", queueName: "Черга 3.1", cityName: "м. Вінниця", streetName: "вулиця Соборна", buildingNumber: "23")
}
