//
//  MakePostViewController.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/2/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import MapKit

class MakePostViewController: UIViewController {

    @IBOutlet weak var locationTextField: CustomTextField!
    @IBOutlet weak var mediaTextField: CustomTextField!
    var placemark: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func findLocationPressed(_ sender: Any) {
        if let location = locationTextField.text, location != "", let website = mediaTextField.text, website != "" {
            forwardGeocoding(location)
        } else {
            UdacityClient.sharedInstance.displayErrorAlert(self, title: "Please enter a location and a valid website")
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        let _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let controller  = segue.destination as! UserPostMapViewController
            controller.placemark = placemark
            controller.mediaURL = mediaTextField.text
            controller.mapString = locationTextField.text
        }
    }
    
    func forwardGeocoding(_ address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if let placemark = placemarks?[0] {
                self.placemark = placemark
                performUIUpdatesOnMain {
                    self.performSegue(withIdentifier: "showMap", sender: nil)
                }
            } else {
                performUIUpdatesOnMain {
                    UdacityClient.sharedInstance.displayErrorAlert(self, title: "Unable to process your location. Please try again!")
                }
            }
        }
    }

}
