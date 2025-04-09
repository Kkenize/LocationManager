//
//  Place.swift
//  LocationManager
//
//  Created by Zhejun Zhang on 4/9/25.
//

import Foundation
import MapKit
import Contacts

struct Place: Identifiable {
    let id: UUID = UUID()
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    init(location: CLLocation) async {
        let geocoder = CLGeocoder()
        do {
            guard let placemark = try await geocoder.reverseGeocodeLocation(location).first else {
                self.init(mapItem: MKMapItem())
                return
            }
            let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
            self.init(mapItem: mapItem)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            self.init(mapItem: MKMapItem())
        }
    }
    
    var name: String {
        self.mapItem.name ?? ""
    }
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: Double {
        self.mapItem.placemark.coordinate.longitude
    }
    
    var address: String {
        // Make sure you import Contacts to use "CN" structures
        let postalAddress = mapItem.placemark.postalAddress ?? CNPostalAddress()
        // Get String that is a multiline formatted postal address
        var address = CNPostalAddressFormatter().string(from: postalAddress)
        address = address.replacingOccurrences(of: "\n", with: ", ")
        
        return address
    }
}
