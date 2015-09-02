//
//  LocuData.swift
//  LocuEx
//
//  Created by Gurmeet Singh on 8/22/15.
//  Copyright (c) 2015 Gurmeet Singh. All rights reserved.
//

import Foundation
import MapKit

class LocuData {
    
    struct Settings {
        static let apiUrl = "https://api.locu.com/v2/venue/search/"
    }

    func request(location: CLLocationCoordinate2D, callback:(NSDictionary)->()) {
        
        var nsURL = NSURL(string: Settings.apiUrl)
        var request = NSMutableURLRequest(URL: nsURL!)
        var response: NSURLResponse?
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var locationRequest = [String:AnyObject]()
        locationRequest["$in_lat_lng_radius"] = [location.latitude,location.longitude,1000]
        
        var params = [  "fields":["name", "location", "contact"],
                        "venue_queries":
                            [
                             [
                               "location"   : [
                                                "geo": locationRequest
                                              ] ,
                               "categories" : [
                                                "name":"Restaurants",
//                                                "str_id" : "chinese"
                                              ]
                             ]
                            ],
                        "api_key":"1a26a2c6c3723c249d27e80c60f418b3c9de8148"
                      ]
        
        var err: NSError?
    
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)

        let requestText = NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding)


        let task = session.dataTaskWithRequest(request) {
            (data,response,error) in
                if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    println("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                println("error submitting request: \(error.localizedDescription)")
                return
            }
            dispatch_async(dispatch_get_main_queue()) {
                var error: NSError?
                if let jsonData = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary {
                    callback(jsonData)
                } else {
                    println("No dictionary received")
                }
            }
        }
        task.resume()
    }
}