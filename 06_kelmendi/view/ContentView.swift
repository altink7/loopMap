//
//  ContentView.swift
//  06_kelmendi
//
//  Created by User on 31.05.23.
//
import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            MapView(region: $viewModel.region, userLocation: viewModel.userLocation)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        if let location = viewModel.userLocation {
                            Text("My Location")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                                .padding()
                            
                            HStack {
                                Text("Latitude:")
                                Text("\(location.latitude), ")
                                Text("Longitude:")
                                Text("\(location.longitude)")
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                        }
                        Spacer()
                    }
                )
            
            VStack {
                Button("Send Notification") {
                    viewModel.sendNotification()
                }
                .padding()
                
                Button("Current Location") {
                    withAnimation {
                        viewModel.requestUserLocation()
                        viewModel.centerMapOnUserLocation()
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.requestUserLocation()
        }
    }
}
