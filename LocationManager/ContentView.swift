//
//  ContentView.swift
//  LocationManager
//
//  Created by Zhejun Zhang on 4/7/25.
//

import SwiftUI

struct ContentView: View {
    @State var locationManager = LocationManager()
    @State var selectedPlace: Place?
    @State private var sheetIsPresented = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(selectedPlace?.name ?? "n/a")
                    .font(.title2)
                Text(selectedPlace?.address ?? "n/a")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text("\(selectedPlace?.latitude ?? 0.0), \(selectedPlace?.longitude ?? 0.0)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
//            Text("\(locationManager.location?.coordinate.latitude ?? 0.0), \(locationManager.location?.coordinate.longitude ?? 0.0)")
//            let _ = print("\(locationManager.location?.coordinate.latitude ?? 0.0), \(locationManager.location?.coordinate.longitude ?? 0.0)")
            
            Spacer()
            
            Button {
                sheetIsPresented.toggle()
            } label: {
                Image(systemName: "location.magnifyingglass")
                Text("Location Search")
            }
        }
        .padding()
        .task {
            if let location = locationManager.location {
                selectedPlace = await Place(location: location)
            }
            
            locationManager.locationUpdated = { location in
                Task {
                    selectedPlace = await Place(location: location)
                }
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            PlaceLookupView(locationManager: locationManager, selectedPlace: $selectedPlace)
        }
    }
}

#Preview {
    ContentView()
}
