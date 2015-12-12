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

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var artworks = [Artwork]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        setupMapView()
        setupLocation()
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(initialLocation)
        
        loadInitialData()
        mapView.addAnnotations(artworks)
    }
    
    let regionRadius: CLLocationDistance = 1000 // 1000 meters (1 kilometer)
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadInitialData() {
        let fileName = NSBundle.mainBundle().pathForResource("PublicArt", ofType: "json");
        let JSONData = JSON(data: NSData(contentsOfFile: fileName!)! )
        
        for artworkJSON in JSONData["data"].arrayValue {
            if
            let artworkJSON = artworkJSON.array,
            let artwork = Artwork.fromJSON(artworkJSON)
            {
                artworks.append(artwork)
            }
        }
    }
    
}

extension ViewController {
    func setupMapView() {
        mapView.mapType = MKMapType.Standard
        
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        mapView.pitchEnabled = true
        mapView.rotateEnabled = true
        mapView.delegate = self
        
        // mapView.showsUserLocation = true
        // mapView.userTrackingMode = MKUserTrackingMode.Follow
        
        // show artwork on map
        let artwork = Artwork(title: "King David Kalakaua",
            locationName: "Waikiki Gateway Park",
            discipline: "Sculpture",
            coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        
        mapView.addAnnotation(artwork)
        
    }
    
    func setupLocation() {
        
    }

}

extension ViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        /*
        let location = userLocation.coordinate
        let region = MKCoordinateRegionMakeWithDistance(location, 250, 250)
        mapView.setRegion(region, animated: true)
        */
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: CustomAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? CustomAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            
            //view.pinColor = annotation.pinColor()
            
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print(status)
    }
}


