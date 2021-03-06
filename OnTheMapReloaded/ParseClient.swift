//
//  ParseClient.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/1/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation

class ParseClient {
    
    let session = URLSession.shared
    
    func taskForUpdateMethod(_ methodParameters: [String:AnyObject], completionHandlerForTaskForUpdate: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        guard let activeStudent = UdacityClient.sharedInstance.activeStudent, let objectID = activeStudent.objectID else {
            completionHandlerForTaskForUpdate(false, NSError(domain: "taskForUpdateMethod", code: 0, userInfo: [NSLocalizedDescriptionKey: "There appears to be an error. Please try again"]))
            return
        }
        let request = NSMutableURLRequest(url: URL(string: "\(ParseClient.Constants.BaseURL)/\(objectID)")!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: methodParameters, options: .prettyPrinted)
        } catch {
            completionHandlerForTaskForUpdate(false, NSError(domain: "taskForUpdateMethod", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error with updating student post"]))
        }
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForTaskForUpdate(false, NSError(domain: "taskForUdpateMethod", code: 0, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let _ = data else {
                sendError("No data was return by the request")
                return
            }
            completionHandlerForTaskForUpdate(true, nil)
        }
        task.resume()
    }
    
    func taskForPostMethod(_ methodParameters: [String:AnyObject], completionHandlerForTaskForPost: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: ParseClient.Constants.BaseURL)!)
        request.httpMethod = "POST"
        request.addValue(ParseClient.Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ParseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: methodParameters, options: .prettyPrinted)
        } catch {
            completionHandlerForTaskForPost(false, NSError(domain: "taskForPostMethod", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error with student post"]))
        }
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForTaskForPost(false, NSError(domain: "taskForPostMethod", code: 0, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let _ = data else {
                sendError("No data was returned by the request")
                return
            }
            completionHandlerForTaskForPost(true, nil)
        }
        task.resume()
    }
    
    func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }

    static let sharedInstance = ParseClient()
}
