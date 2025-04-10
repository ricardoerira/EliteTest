//
//  LocationManager.swift
//  EliteTest
//
//  Created by Wilson Ricardo Erira  on 8/04/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var location: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        locationManager.stopUpdatingLocation() // Detener actualizaciones para conservar batería
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación: \(error.localizedDescription)")
    }
}
