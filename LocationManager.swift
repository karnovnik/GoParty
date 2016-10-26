//
//  LocationManagerHelper.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/25/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var currentGeolocation: CLLocation?
    
    // Юлия 55.892271, 37.270599
    
    override init() {
        super.init()
        
        createLocationManager()
    }
    
    private func createLocationManager() {
        if ( CLLocationManager.locationServicesEnabled() ) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Location services are not enabled");
        }
    }
    
    @objc func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        currentGeolocation = locations.last! as CLLocation
        locationManager.stopUpdatingLocation()
    }
    
    func updateCurrentGeolocation() {
        if locationManager == nil {
            createLocationManager()
        } else {
            if ( CLLocationManager.locationServicesEnabled() ) {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func getCurrentGeolocation() -> CLLocation? {
        return currentGeolocation
    }
}

