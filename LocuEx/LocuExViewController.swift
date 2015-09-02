//
//  LocuExViewController.swift
//  LocuEx
//
//  Created by Gurmeet Singh on 8/22/15.
//  Copyright (c) 2015 Gurmeet Singh. All rights reserved.
//

import UIKit
import MapKit

class LocuExViewController: UIViewController, MKMapViewDelegate {

    var initialLocationUpdated = false
    
    var location: CLLocation! {
        didSet {
            if !initialLocationUpdated {
                moveMapToLocation(location.coordinate)
                requestLocuData()
                initialLocationUpdated = true
            }
        }
    }

    var service:LocuData!

    func requestLocuData()
    {
        service = LocuData()
        // Async request for Locu Data
        service.request(self.location!.coordinate)  {
            (response) in
            self.locuData = response
        }
    }
    
    var locationManager = LocationManager()
    
    var error: NSError?
    var venues =  [Venue]()
    var locuData = [:]
        {
        didSet {
            if mapView != nil {
                updateMap(mapView)
            }
        }
    }

    func moveMapToLocation(loc:CLLocationCoordinate2D) {
        mapView.centerCoordinate = loc
        let region = MKCoordinateRegionMakeWithDistance(loc, 2000, 2000)
        mapView.setRegion(region, animated: true)
    }
    
    func updateMap(mapView:MKMapView){
      mapView.removeAnnotations(self.venues)
      self.venues = Venue.venueListFromDict(self.locuData)
      mapView.addAnnotations(self.venues)
      mapView.showAnnotations(self.venues, animated: false)
    }

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.mapType = .Standard
            mapView.rotateEnabled = false
        }
    }
    
    @IBAction func moveToCurrentLocation(sender: UIBarButtonItem) {
      initialLocationUpdated = false
      requestCurrentLocation()
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        if initialLocationUpdated {
            location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            requestLocuData()
        }
    }
    
    private struct Constants {
        static let ShowVenueSegue = "Show Venue"
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("AnnotationReuseIdentifier")
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationReuseIdentifier")
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        
        view.leftCalloutAccessoryView = nil
        view.rightCalloutAccessoryView = nil
        
        view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        
        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if (control as? UIButton)?.buttonType == UIButtonType.DetailDisclosure {
            mapView.deselectAnnotation(view.annotation, animated: false)
            performSegueWithIdentifier(Constants.ShowVenueSegue, sender: view)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.ShowVenueSegue {
            if let venue = (sender as? MKAnnotationView)?.annotation as? Venue {
                if let ivc = segue.destinationViewController.contentViewController as? VenueTableViewController {
                    ivc.venue = venue
                }
            }
        }
    }

    func requestCurrentLocation() {
        // Async request for current location
        locationManager.request {
            (location, error)  in
            self.location = location
            self.error = error
        }
 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        requestCurrentLocation()
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let nc = self as? UINavigationController {
            return nc.visibleViewController
        } else {
            return self
        }
    }
}

