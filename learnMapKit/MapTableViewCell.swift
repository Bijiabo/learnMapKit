//
//  MapTableViewCell.swift
//  learnMapKit
//
//  Created by huchunbo on 15/12/12.
//  Copyright © 2015年 Bijiabo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapTableViewCell: UITableViewCell, FMKMapViewControllerProtocol {

    @IBOutlet weak var mapView: MKMapView!
    
    var regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var artworks = [Artwork]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // map view
        setupMapView()
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(initialLocation)
        
        loadInitialData()
        mapView.addAnnotations(artworks)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MapTableViewCell: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print(status)
    }
}

extension MapTableViewCell: FMKMapViewDelegateProtocol {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        return FMapView(mapView, viewForAnnotation: annotation)
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        FMapView(mapView, annotationView: view, calloutAccessoryControlTapped: control)
    }
}