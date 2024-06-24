//
//  MainView.swift
//  EDClient
//
//  Created by Oleksii Chumak on 16.06.2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var pinnedAddresses: [PinnedAddress]
    
    @State private var isShowingForm = false
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack {
                    List {
                        ForEach(pinnedAddresses, id: \.self) { pinnedAddress in
                            NavigationLink {
                                ScheduleView(addressInfo: pinnedAddress as Address)
                            } label: {
                                PinnedAddressItemView(pinnedAddress: pinnedAddress)
                            }
                        }
                        .onDelete { offset in
                            // needs realization through the client and server
                            unpinAddress(offsets: offset)
                        }
                    }.listStyle(.inset)
                }
                .navigationTitle("pinnedAddressesTitle")
                
                
                
                
                Button(action: {
                    isShowingForm.toggle()
                }) {
                    Text("getScheduleText")
                        .font(.title2)
                        .bold()
                        .padding()
                        .foregroundStyle(.white)
                        .background(TimelineView(.animation) { timeline in
                            let now = timeline.date.timeIntervalSinceReferenceDate
                            let angle = Angle.degrees(now.truncatingRemainder(dividingBy: 20) * 18)
                            AngularGradient(
                                gradient: Gradient(colors: [.orange, .pink, .indigo, .purple, .orange.opacity(3)]),
                                center: .center,
                                startAngle: .degrees(angle.degrees),
                                endAngle: .degrees(angle.degrees + 360)
                            )
                            .blur(radius: 4, opaque: false)
                        })
                        .clipShape(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                        )
                        .padding()
                }
            }
            .sheet(isPresented: $isShowingForm) {
                VStack {
                    Image(systemName: "chevron.compact.down")
                        .resizable()
                        .symbolEffect(.scale)
                        .frame(width: 36, height: 12)
                        .foregroundStyle(Gradient(colors: [.indigo, .purple]))
                        .padding(EdgeInsets(top: 18, leading: 1, bottom: 0, trailing: 1))
                    AddressChoosingView()
                }.background(Color(.secondarySystemBackground))
            }
            .onAppear {
                
            }
        }
    }
    
    private func unpinAddress(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(pinnedAddresses[index])
            }
        }
    }
}

#Preview {
    MainView()
}
