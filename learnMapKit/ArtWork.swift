//
// Created by huchunbo on 15/12/11.
// Copyright (c) 2015 Bijiabo. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import AddressBook

public class Artwork: NSObject, MKAnnotation {
    public let title: String?
    let locationName: String
    let discipline: String
    public let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    public var subtitle: String? {
        return locationName
    }
    
    // annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        var subtitle: AnyObject = ""
        if let self_subtitle = self.subtitle as? AnyObject {subtitle = self_subtitle}
        
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
    class func fromJSON(json: [JSON]) -> Artwork? {
        var title: String
        if let titleOrNil = json[16].string {
            title = titleOrNil
        } else {
            title = ""
        }
        let locationName = json[12].stringValue
        let discipline = json[15].stringValue
        
        let latitude = json[18].doubleValue
        let longitude = json[19].doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        return Artwork(title: title, locationName: locationName, discipline: discipline, coordinate: coordinate)
    }
    
    // pinColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    func pinColor() -> MKPinAnnotationColor  {
        switch discipline {
        case "Sculpture", "Plaque":
            return .Red
        case "Mural", "Monument":
            return .Purple
        default:
            return .Green
        }
    }
}

class CustomAnnotationView: MKAnnotationView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        var myFrame: CGRect = self.frame
        myFrame.size.width = 40.0
        myFrame.size.height = 40.0
        self.frame = myFrame
        self.image = UIImage(named: "cat")
        self.opaque = false
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}