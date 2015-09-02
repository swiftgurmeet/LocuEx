//
//  LocationManager.swift
//  LocuEx
//
//  Created by Gurmeet Singh on 8/23/15.
//  Copyright (c) 2015 Gurmeet Singh. All rights reserved.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate {
    
    typealias LocationClosure = ((location: CLLocation?, error: NSError?)->())
    var locationManager = CLLocationManager()
    var doneOnce = false
    var cb: LocationClosure?
    
    func request(callback: LocationClosure) {
        locationManager.stopUpdatingLocation()
        doneOnce = false
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        self.cb = { (lc) in
            dispatch_async(dispatch_get_main_queue()) {
                callback(lc)
            }
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        
        if let location = locations[0] as? CLLocation {
            if !doneOnce {
               self.cb!(location: location, error: nil)
               doneOnce = true
            }
        } else {
            self.cb!(location: nil, error: NSError(domain: self.classForCoder.description(), code: Int(CLAuthorizationStatus.NotDetermined.rawValue), userInfo: nil ))
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
          case .AuthorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
          case .Denied:
            break
          default:
            break
        }
    }
}
