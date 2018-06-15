//
//  AllListingsMapVC.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 5/21/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class AllListingsMapVC: UIViewController, MKMapViewDelegate {
    
    var anno:Listing.standardFields!
    var locationManager = CLLocationManager()
    var listingAnnos:[ListingAnno] = [ListingAnno]()
    
    var mapView = MKMapView()
    var listing:Listing!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mapView
        mapView.delegate = self
        
//        Listing.standardFields.fetchListing { (listing) in
//            self.listingAnnos = self.listingAnnos
//        }

        fetchListings()
//        print(Listing.listingResults.self)
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view:MKPinAnnotationView
        let identifier = "Pin"
        
        if annotation is MKUserLocation{
            return nil//use the blue dot
        }
        if annotation !== mapView.userLocation {
            //try to reuse the view
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation =  annotation
                view = dequeuedView
            } else {
                //finish
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.pinTintColor = MKPinAnnotationView.purplePinColor()
                view.canShowCallout = true
                view.animatesDrop = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let leftButton = UIButton(type: .infoLight)
                let rightButton = UIButton(type: .detailDisclosure)
                leftButton.tag = 0
                rightButton.tag = 1
                view.leftCalloutAccessoryView = leftButton
                view.rightCalloutAccessoryView = rightButton
                
            }
            return view
        }
        return nil
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            
            let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = view.annotation!.title!
            let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
            
            
            mapItem.openInMaps(launchOptions: launchOptions)
            
            
            
            
        }
    }
    
    
    func fetchListings() {
        

        //var json = listingAnnos as Array<Any>
        var json = listingAnnos as Array<Any>
        json.append(listingAnnos)
            print(json)
        let listingAnno:ListingAnno = ListingAnno(title: anno.UnparsedAddress, coordinate: CLLocationCoordinate2D.init(latitude: anno.Latitude, longitude: anno.Longitude))
        print(listingAnno)
                    for dictionary in json as! [[String:Any]] {
//                        //let dataDictionary = json
                        let title = anno.UnparsedAddress
                        let lat = anno.Latitude
                        let lon = anno.Longitude
                        let coordinate = CLLocationCoordinate2DMake(lat, lon)
                        let listingAnnos:ListingAnno = ListingAnno(title: title, coordinate: coordinate)
                        print(dictionary)
//                        self.listingAnnos.append(listingAnno)
//
//                        var thePoint = MKPointAnnotation()
//                        thePoint = MKPointAnnotation()
//                        thePoint.coordinate = listingAnno.coordinate
//                        thePoint.title = listingAnno.title
//                        //thePoint.subtitle = listingAnno.locationName
//                        self.mapView.addAnnotation(thePoint)
                    }
        }

    }

