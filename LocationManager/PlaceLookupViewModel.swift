//
//  PlaceLookupViewModel.swift
//  LocationManager
//
//  Created by Zhejun Zhang on 4/9/25.
//

import Foundation
import MapKit

@Observable
@MainActor
class PlaceViewModel {
    var places: [Place] = []
    
    func search(text: String, region: MKCoordinateRegion) async throws {
        // Create a search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        
        let search = MKLocalSearch(request: searchRequest)
        let response = try await search.start()
        if response.mapItems.isEmpty {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No location found"])
        }
        self.places = response.mapItems.compactMap(Place.init)
    }
}
