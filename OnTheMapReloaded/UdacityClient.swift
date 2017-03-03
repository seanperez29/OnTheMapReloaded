//
//  UdacityClient.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/1/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation
import MapKit

class UdacityClient: NSObject {
    
    static let sharedInstance = UdacityClient()
    var session = URLSession.shared
    var sessionID: String?
    var firstName: String?
    var lastName: String?
    var uniqueID: String?
    
    func displayErrorAlert(_ viewController: UIViewController, title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        performUIUpdatesOnMain {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func udacityURLFromParameters(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
}
