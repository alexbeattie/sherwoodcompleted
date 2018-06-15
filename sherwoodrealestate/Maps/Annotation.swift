//
//  Annotation.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 5/21/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import MapKit
import Contacts

class ListingAnno: NSObject, MKAnnotation, Codable {
    var anno: Listing.standardFields?
    
    //let title: String?
    let coordinate: CLLocationCoordinate2D
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, radius
    }
    init(title:String, coordinate: CLLocationCoordinate2D) {
        //self.title = title
        self.coordinate = coordinate
        super.init()
    }
    var title: String? {
    
        return nil
        }
    

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}
     func fromDataArray(dictionary: [String:Any]!)->ListingAnno {

        var latitude:Double = 0.0
        var longitude:Double = 0.0
        var title = ""

        var listing: Listing.listingResults? {
            didSet {
                if let theAddress = listing?.StandardFields.UnparsedAddress {
                    title = theAddress
                }
                if let theLng = listing?.StandardFields.Longitude {
                    longitude = theLng
                }
                if let theLat = listing?.StandardFields.Latitude {
                    latitude = theLat
                }


            }
        }
    
        let location2d:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: (listing?.StandardFields.Latitude)!, longitude: (listing?.StandardFields.Longitude)!)
        return ListingAnno.init(title: title, coordinate: location2d)
    }



