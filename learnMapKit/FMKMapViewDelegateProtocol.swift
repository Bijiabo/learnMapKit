//
//  FMKDelegateProtocol.swift
//  learnMapKit
//
//  Created by huchunbo on 15/12/12.
//  Copyright © 2015年 Bijiabo. All rights reserved.
//

import Foundation
import MapKit

protocol FMKMapViewDelegateProtocol: MKMapViewDelegate {
    func FMapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation)
    func FMapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    func FMapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    func FMapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
}

extension FMKMapViewDelegateProtocol {
    
    func FMapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        /*
        let location = userLocation.coordinate
        let region = MKCoordinateRegionMakeWithDistance(location, 250, 250)
        mapView.setRegion(region, animated: true)
        */
    }
    
    func FMapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: CustomAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? CustomAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
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
    
    func FMapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    func FMapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
    }
}