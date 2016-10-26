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

class CreateEventMapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var Map: MKMapView!
    var location: CLLocation? = nil
    
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
        }
    }
}
