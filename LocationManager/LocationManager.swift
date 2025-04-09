//
//  LocationManager.swift
//  LocationManager
//
//  Created by Zhejun Zhang on 4/7/25.
//

import Foundation
import MapKit
import SwiftUI

@Observable

class LocationManager: NSObject, CLLocationManagerDelegate {
    // *** CRITICALLY IMPORTANT *** Always add info.plist message for Privacy - Location when in Use Usage Description
    
    var location: CLLocation?
    var placeMark: CLPlacemark?
    private let locationManager = CLLocationManager()
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var errorMessage: String?
    var locationUpdated: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getRegionAroundCurrentLocation(radiusInMeters: CLLocationDistance = 10000) -> MKCoordinateRegion? {
        guard let location = location else { return nil }
        
        return MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radiusInMeters,
            longitudinalMeters: radiusInMeters
        )
    }
}

// Delegate methods that Apple has created & will call, but that we filled out
extension LocationManager {
    func locationManager (_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        location = newLocation
        
        locationUpdated?(newLocation)
        
        // You can comment out if you only want to get the location once
         manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("LocationManager: authorization granted.")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("LocationManager: authorization denied or restricted.")
            manager.stopUpdatingLocation()
        case .notDetermined:
            print("LocationManager: authorization not determined")
            manager.requestWhenInUseAuthorization()
        @unknown default:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        errorMessage = error.localizedDescription
        print("Error: LocationManager \(errorMessage ?? "n/a")")
    }
}
