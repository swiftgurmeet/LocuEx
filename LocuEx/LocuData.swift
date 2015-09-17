//
//  LocuData.swift
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
                        "api_key":""
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
