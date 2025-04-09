//
//  GoogleMapView.swift
//  EliteTest
//
//  Created by andres on 8/04/25.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    @ObservedObject var locationManager = LocationManager()
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 4.710989, longitude: -74.072092, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        if let userLocation = locationManager.location?.coordinate {
            let updatedCamera = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: 15.0)
            mapView.animate(to: updatedCamera)
        }

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Actualizar la vista si es necesario
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView

        init(_ parent: GoogleMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            parent.selectedCoordinate = coordinate
            mapView.clear()
            let marker = GMSMarker(position: coordinate)
            marker.title = "Ubicación seleccionada"
            marker.map = mapView
        }
    }
}
