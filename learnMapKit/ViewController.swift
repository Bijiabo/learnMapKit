//
//  ViewController.swift
//  learnMapKit
//
//  Created by huchunbo on 15/12/5.
//  Copyright © 2015年 Bijiabo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, FMKMapViewControllerProtocol {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var artworks = [Artwork]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Full Screen"
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // map view
        setupMapView()
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(initialLocation)
        
        loadInitialData()
        mapView.addAnnotations(artworks)
    }
    
    var regionRadius: CLLocationDistance = 1000 // 1000 meters (1 kilometer)
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print(status)
    }
}

extension ViewController: FMKMapViewDelegateProtocol {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        return FMapView(mapView, viewForAnnotation: annotation)
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        FMapView(mapView, annotationView: view, calloutAccessoryControlTapped: control)
    }
}