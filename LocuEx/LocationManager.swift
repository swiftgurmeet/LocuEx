//
//  LocationManager.swift
//  LocuEx
//
//The MIT License (MIT)
//
//Copyright (c) 2015 swiftgurmeet
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.


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
