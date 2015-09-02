//
//  Venue.swift
//  LocuEx
//
//  Created by Gurmeet Singh on 8/24/15.
//  Copyright (c) 2015 Gurmeet Singh. All rights reserved.
//

import Foundation
import MapKit

class Venue: NSObject, MKAnnotation {
    
    var locuId = ""
    var name = ""
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var phoneNumber = ""
    var address = ""
    
    init(name: String)
    {
      self.name = name
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
          return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        }
    }
    
    var title:String {
        return self.name
    }
    
    func setCoordinate(c: CLLocationCoordinate2D) -> () {
        self.longitude = c.longitude
        self.latitude = c.latitude
    }
    
    
    class func venueListFromDict(dict: NSDictionary) -> [Venue] {
        
        var list = [Venue]()
        
        if let venues = dict.valueForKeyPath("venues") as? NSArray {
            for v in venues {
                var nv = Venue(name: "")
                if let name = v["name"] as? String {
                     nv.name = name
                }
                if let p = v.valueForKeyPath("contact.phone") as? String {
                    nv.phoneNumber = p
                }
                if let p = v.valueForKeyPath("location.address1") as? String {
                    nv.address = p
                }
                if let p = v.valueForKeyPath("location.locality") as? String {
                    nv.address += ("\n" + p)
                }
                if let p = v.valueForKeyPath("location.region") as? String {
                    nv.address += (", " + p)
                }
                if let p = v.valueForKeyPath("location.postal_code") as? String {
                    nv.address += (" " + p)
                }
                if let c = v.valueForKeyPath("location.geo.coordinates") as? [Double] {
                    nv.longitude = c[0]
                }
                if let c = v.valueForKeyPath("location.geo.coordinates") as? [Double] {
                   nv.latitude = c[1]
                }
                list.append(nv)
           }
        }
        return list
    }
}