//
//  AddressInfoView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 15.06.2024.
//

import SwiftUI

struct AddressInfoView: View {
    var day: String
    var queue: String
    var cityName: String
    var streetName: String
    var buildingNumber: String
    
    @State private var rotation: Double = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .center, spacing: 8) {
                Text(day.capitalized(with: .current))
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
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
                    .clipShape(RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    ))
                    .padding(4)
                    .background(.orange)
                    .clipShape(RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    ))
                    .shadow(color: .white.opacity(0.5), radius: 8)
                
                
                Text(queue)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    ))
                    .shadow(color: .white.opacity(0.5), radius: 8)
                    .padding(6)
                
                Text("\(cityName), \(streetName) \(buildingNumber)")
                    .font(.caption)
                    .lineLimit(10)
                    .padding(.horizontal, 8)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .italic()
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    ))
                    .shadow(color: .white.opacity(0.53), radius: 8)
                
            }
            .padding()
        }
        .onAppear {
            rotation = 360
        }
        .background(LinearGradient(colors: [.orange.opacity(3), .pink.opacity(2), .indigo.opacity(3)], startPoint: .bottomTrailing, endPoint: .topLeading)
            .grayscale(0.25))
        
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
    AddressInfoView(day: "Пт 21.06", queue: "Черга 3.1", cityName: "м. Вінниця", streetName: "вулиця Соборна", buildingNumber: "23")
}
