//
//  Location.swift
//  06_kelmendi
//
//  Created by User on 31.05.23.
//
import Foundation
import CoreLocation

struct Location: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
}
