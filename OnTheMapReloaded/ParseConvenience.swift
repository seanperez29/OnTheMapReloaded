//
//  ParseConvenience.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/1/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func postStudentLocation(_ uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForPostStudent: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let methodParameters: [String:Any] = [ParseClient.JSONParameterKeys.uniqueKey: uniqueKey, ParseClient.JSONParameterKeys.firstName: firstName, ParseClient.JSONParameterKeys.lastName: lastName, ParseClient.JSONParameterKeys.mapString: mapString, ParseClient.JSONParameterKeys.mediaURL: mediaURL, ParseClient.JSONParameterKeys.latitude: latitude, ParseClient.JSONParameterKeys.longitude: longitude]
        taskForPostMethod(methodParameters as [String: AnyObject]) { (success, error) in
            if success {
                completionHandlerForPostStudent(true, nil)
            } else {
                completionHandlerForPostStudent(false, "There appears to have been an error: \(error)")
            }
        }
    }
    
    func updateStudentLocation(_ uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForUdpateStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let methodParameters: [String:Any] = [ParseClient.JSONParameterKeys.uniqueKey: uniqueKey, ParseClient.JSONParameterKeys.firstName: firstName, ParseClient.JSONParameterKeys.lastName: lastName, ParseClient.JSONParameterKeys.mapString: mapString, ParseClient.JSONParameterKeys.mediaURL: mediaURL, ParseClient.JSONParameterKeys.latitude: latitude, ParseClient.JSONParameterKeys.longitude: longitude]
        taskForUpdateMethod(methodParameters as [String: AnyObject]) { (success, error) in
            if success {
                completionHandlerForUdpateStudentLocation(true, nil)
            } else {
                completionHandlerForUdpateStudentLocation(false, "There appears to have been an error: \(error)")
            }
        }
        
    }
    
    func getStudentLocations(_ completionHandler: @escaping (_ students: [StudentLocation]?, _ success: Bool, _ errorString: String?) -> Void) {
        let requestParameters = [UdacityClient.JSONRequestKeys.Limit: UdacityClient.JSONRequestValues.Limit100]
        let request = NSMutableURLRequest(url: parseURLFromParameters(requestParameters as [String:AnyObject]))
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard (error == nil) else {
                completionHandler(nil, false, "There was an error with your request: \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(nil, false, "Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                completionHandler(nil, false, "No data was returned by the request")
                return
            }
            var parsedResult: AnyObject
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                print(error)
                return
            }
            let results = parsedResult["results"] as! [[String:AnyObject]]
            let students = StudentLocation.studentLocationFromResults(results)
            completionHandler(students, true, nil)
        }
        task.resume()
    }
}
