//
//  CreateEventMapViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/25/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CreateEventMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var Map: MKMapView!
    var location: CLLocation? = nil
    
    var key = CreateEventItemsKeys.NONE
    var returnResultsCallback: ((CreateEventItemsKeys, AnyObject)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if location != nil {
            let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
            
            Map.setRegion(region, animated: true)
            
            let annotationCoordinats = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.title = "You are here"
            annotation.coordinate = annotationCoordinats
            
            Map.addAnnotation( annotation )
            
            Map.delegate = self
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print( userLocation )
        returnResultsCallback!( key, userLocation )
        // Not getting called
    }
    
}
