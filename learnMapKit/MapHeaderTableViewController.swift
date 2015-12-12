//
//  MapHeaderTableViewController.swift
//  learnMapKit
//
//  Created by huchunbo on 15/12/12.
//  Copyright © 2015年 Bijiabo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapHeaderTableViewController: UITableViewController, FMKMapViewControllerProtocol {
    
    //mapView
    var mapView: MKMapView! = MKMapView()
    let locationManager = CLLocationManager()
    var artworks = [Artwork]()
    var regionRadius: CLLocationDistance = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private var hasSetupMapHeaderView: Bool = false
    private var scrollViewOriginOffSetY: CGFloat = 0
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !hasSetupMapHeaderView {
            setupMapHeaderView()
            
            if tableView.scrollsToTop {
                tableView.contentOffset = CGPointMake(0, -tableView.contentInset.top)
                scrollViewOriginOffSetY = tableView.contentOffset.y
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("normalCell", forIndexPath: indexPath) as! NormalTableViewCell

        return cell
    }

    // custom table header view
    private func setupMapHeaderView() {
        // init location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // map view
        setupMapView()
        // set location
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(initialLocation)
        // load data
        loadInitialData()
        mapView.addAnnotations(artworks)
        
        setupCustomHeaderView()
    }
    
    private func setupCustomHeaderView() {
        // set the height for header view
        let customHeaderViewHeight: CGFloat = 400.0
        var viewDict: [String: UIView] = [String: UIView]()
        var metrics: [String: Int] = [String: Int]()

        // set tableView's headerView
        let customHeaderView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: customHeaderViewHeight))
        customHeaderView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        customHeaderView.clipsToBounds = false
        
        // add mapView container
        let mapContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: customHeaderViewHeight))
        mapContainerView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mapContainerView.clipsToBounds = false
        mapContainerView.tag = 1024 // this is important
        customHeaderView.addSubview(mapContainerView)
        
        func addConstraintsToMapViewContainerByFormat(format: String) {
            mapContainerView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                    format ,
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: metrics, views: viewDict)
            )
        }
        
        // add mapView to container
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapContainerView.addSubview(mapView)
        viewDict["mapView"] = mapView
        metrics["verticalMargin"] = -100
        mapContainerView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-[mapView]-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics, views: viewDict)
        )
        mapContainerView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-(verticalMargin)-[mapView]-(verticalMargin)-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics, views: viewDict)
        )
        
        // add verticalGradient image
        let verticalGradientImageView = UIImageView()
        verticalGradientImageView.image = UIImage(named: "verticalGradient")
        verticalGradientImageView.translatesAutoresizingMaskIntoConstraints = false
        mapContainerView.addSubview(verticalGradientImageView)
        viewDict["verticalGradientView"] = verticalGradientImageView
        metrics["verticalGradientViewHeight"] = 0 - metrics["verticalMargin"]!
        mapContainerView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-[verticalGradientView]-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics, views: viewDict)
        )
        mapContainerView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-(verticalMargin)-[verticalGradientView(verticalGradientViewHeight)]",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics, views: viewDict)
        )
        
        tableView.tableHeaderView = customHeaderView
        tableView.sendSubviewToBack(tableView.tableHeaderView!)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let tableHeaderView = tableView.tableHeaderView else {return}
        guard let mapContainerView = tableHeaderView.viewWithTag(1024) else {return}
        if scrollView.contentOffset.y < scrollViewOriginOffSetY {return}
        
        mapContainerView.layer.frame.origin.y = (scrollView.contentOffset.y - scrollViewOriginOffSetY)/2
    }
}


extension MapHeaderTableViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print(status)
    }
}

extension MapHeaderTableViewController: FMKMapViewDelegateProtocol {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        return FMapView(mapView, viewForAnnotation: annotation)
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        FMapView(mapView, annotationView: view, calloutAccessoryControlTapped: control)
    }
}