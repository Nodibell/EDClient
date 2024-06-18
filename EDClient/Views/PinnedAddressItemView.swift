//
//  PinnedAddressItemView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 17.06.2024.
//

import SwiftUI

struct PinnedAddressItemView: View {
    @State var pinnedAddress: PinnedAddress
    
    var body: some View {
        HStack {
            Image(systemName: "house.circle.fill")
                .font(.largeTitle)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.yellow, .blue)
                
            VStack{
                HStack {
                    Text(pinnedAddress.cityName)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                HStack {
                    Text("\(pinnedAddress.streetName) \(pinnedAddress.buildingNumber)" )
                        .font(.callout)
                        .foregroundStyle(.primary)
                        .bold()
                    Spacer()
                }
            }
            .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    PinnedAddressItemView(pinnedAddress: PinnedAddress.init(cityName: "місто Вінниця(Вінницький район/м. Вінниця)", streetName: "вулиця Соборна", buildingNumber: "29", cityID: 1, streetID: 1, buildingID: 1))
}
