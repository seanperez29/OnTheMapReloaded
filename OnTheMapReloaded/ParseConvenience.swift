//
//  ParseConvenience.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/1/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation

extension ParseClient {
    
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
