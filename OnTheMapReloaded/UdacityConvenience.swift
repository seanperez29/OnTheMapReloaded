//
//  UdacityConvenience.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/1/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func authenticateStudentLogin(username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        getSessionID(username, password: password) { (success, errorString) in
            if success {
                completionHandlerForAuth(true, errorString)
            } else {
                completionHandlerForAuth(false, errorString)
            }
        }
    }
    
    func getSessionID(_ username: String, password: String, completionHandlerForSessionID: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard (error == nil) else {
                completionHandlerForSessionID(false, "There was an error with your request: '\(error)'")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completionHandlerForSessionID(false, "No internet connection. Please obtain internet access")
                return
            }
            if statusCode == 403 {
                completionHandlerForSessionID(false, "Account not found or invalid credentials")
                return
            } else if !(statusCode >= 200 && statusCode <= 299) {
                completionHandlerForSessionID(false, "Unknow error, please try again")
                return
            }
            guard let data = data else {
                completionHandlerForSessionID(false, "No data was returned by the request")
                return
            }
            
            let newData = data.subdata(in: 5..<data.count)
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                completionHandlerForSessionID(false, "Could not parse data as JSON: '\(data)'")
                return
            }
            guard let account = parsedResult[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject] else {
                completionHandlerForSessionID(false, "Could not obtain account information")
                return
            }
            guard let key = account[UdacityClient.JSONResponseKeys.Key] as? String else {
                completionHandlerForSessionID(false, "Could not obtain key")
                return
            }
            self.uniqueID = key
            self.getUserData(completionHandlerForSessionID)
        }
        task.resume()
    }
    
    func getUserData(_ completionHandlerForData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        guard let uniqueID = uniqueID else {
            completionHandlerForData(false, "There was an error obtaining a uniqueID")
            return
        }
        let request = NSMutableURLRequest(url: udacityURLFromParameters(nil, withPathExtension: "/users/\(uniqueID)"))
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard (error == nil) else {
                completionHandlerForData(false, "There was an error with your request: \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForData(false, "Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                completionHandlerForData(false, "No data was returned by the request")
                return
            }
            let newData = data.subdata(in: 5..<data.count)
            let parsedResult: AnyObject
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                completionHandlerForData(false, "Could not parse the data as JSON: '\(newData)'")
                return
            }
            guard let user = parsedResult[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] else {
                completionHandlerForData(false, "Error obtaining user information")
                return
            }
            guard let firstName = user[UdacityClient.JSONResponseKeys.FirstName] as? String else {
                completionHandlerForData(false, "Error obtaining first name")
                return
            }
            guard let lastName = user[UdacityClient.JSONResponseKeys.LastName] as? String else {
                completionHandlerForData(false, "Error obtaining las name")
                return
            }
            self.activeStudent = Student(firstName: firstName, lastName: lastName, uniqueID: uniqueID)
            completionHandlerForData(true, nil)
        }
        task.resume()
    }
    
    
}
