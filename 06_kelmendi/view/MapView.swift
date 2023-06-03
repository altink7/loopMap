//
//  MapView.swift
//  06_kelmendi
//
//  Created by User on 31.05.23.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var userLocation: Location?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Smoothly animate the region change
        if !coordinateSpanEquals(region.span, uiView.region.span) || !coordinateEquals(region.center, uiView.region.center) {
            UIView.animate(withDuration: 0.3) {
                uiView.setRegion(region, animated: true)
            }
        }
        
        if let location = userLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            uiView.addAnnotation(annotation)
            uiView.showAnnotations([annotation], animated: true)
        }
    }
    
    private func coordinateSpanEquals(_ span1: MKCoordinateSpan, _ span2: MKCoordinateSpan) -> Bool {
        return span1.latitudeDelta == span2.latitudeDelta && span1.longitudeDelta == span2.longitudeDelta
    }
    
    private func coordinateEquals(_ coordinate1: CLLocationCoordinate2D, _ coordinate2: CLLocationCoordinate2D) -> Bool {
        return coordinate1.latitude == coordinate2.latitude && coordinate1.longitude == coordinate2.longitude
    }
}


