//
//  AddressChoosingView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 13.06.2024.
//

import SwiftUI

struct AddressChoosingView: View {
    @State private var searchText: String = ""
    @State private var prompts = []
    @EnvironmentObject var addressInfo: FormAddress
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(InformationType.city.localizedName) {
                        PromptsShowView(promptType: .city)
                    }
                    Text(addressInfo.cityName)
                }
                Section {
                    NavigationLink(InformationType.street.localizedName) {
                        PromptsShowView(promptType: .street)
                    }
                    .disabled(addressInfo.cityName.isEmpty)
                    Text(addressInfo.streetName)
                }
                Section {
                    NavigationLink(InformationType.building.localizedName) {
                        PromptsShowView(promptType: .building)
                    }
                    .disabled(addressInfo.streetName.isEmpty)
                    Text(addressInfo.buildingNumber)
                }
                
                Section {
                    Label(LocalizedStringKey("fullAddress"), systemImage: "house.fill").font(.headline)
                    Text("\(addressInfo.cityName)\n\(addressInfo.streetName) \(addressInfo.buildingNumber)")
                    
                } header: {
                    Text("scheduleFor")
                }
                
                NavigationLink {
                    ScheduleView(addressInfo: addressInfo as Address)
                } label: {
                    Text("confirmationButton")
                }
                .disabled(checkDisabled())
            }
            .navigationTitle(LocalizedStringKey("scheduleFormTitle"))
        }
        .onAppear {
            addressInfo.makeEmpty()
        }
    }
    
    private func checkDisabled() -> Bool {
        return addressInfo.streetName.isEmpty || addressInfo.cityName.isEmpty || addressInfo.buildingNumber.isEmpty
    }
}

#Preview {
    AddressChoosingView()
}
