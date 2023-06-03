//
//  ContentViewModel.swift
//  06_kelmendi
//
//  Created by User on 31.05.23.
//
import Foundation
import CoreLocation
import UserNotifications
import MapKit

class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    private let locationManager = CLLocationManager()
    @Published var region = MKCoordinateRegion()
    @Published var userLocation: Location?
    
    override init() {
        super.init()
        locationManager.delegate = self
        UNUserNotificationCenter.current().delegate = self
        requestNotificationAuthorization()
    }
    
    func requestUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification authorization granted")
            } else if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        if let location = userLocation {
            content.title = "Current Location"
            content.body = "Latitude: \(location.latitude)\nLongitude: \(location.longitude)"
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = location.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let newRegion = MKCoordinateRegion(center: coordinate, span: span)
            self.region = newRegion
            self.userLocation = Location(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    func centerMapOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let newRegion = MKCoordinateRegion(center: location, span: span)
            self.region = newRegion
        }
    }
    
    // Handle notification when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // Handle user interaction with the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the user's response if needed
        completionHandler()
    }
}

