//
//  StudentLocation.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/1/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation
import MapKit

class StudentLocation {
    
    var objectID: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    init(dictionary: [String:AnyObject]) {
        objectID = dictionary["objectId"] as? String
        uniqueKey = dictionary["uniqueId"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        latitude = dictionary["latitude"] as? CLLocationDegrees
        longitude = dictionary["longitude"] as? CLLocationDegrees
     }
    
    static func studentLocationFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        return studentLocations
    }
    
    
}
