//
//  UserPostMapViewController.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/3/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import MapKit

class UserPostMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    var mediaURL: String!
    var placemark: CLPlacemark!
    var mapString: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        placePinOnMap(placemark)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        guard let activeStudent = UdacityClient.sharedInstance.activeStudent else {
            UdacityClient.sharedInstance.displayErrorAlert(self, title: "There appears to be an error. Please try again")
            return
        }
        ParseClient.sharedInstance.postStudentLocation(activeStudent.uniqueID, firstName: activeStudent.firstName, lastName: activeStudent.lastName, mapString: mapString, mediaURL: mediaURL, latitude: placemark.location!.coordinate.latitude, longitude: placemark.location!.coordinate.longitude) { (success, errorString) in
            if success {
                let _ = self.navigationController?.popToRootViewController(animated: true)
            } else {
                UdacityClient.sharedInstance.displayErrorAlert(self, title: "There was an error submitting your post. Please try again")
            }
        }
    }
    
    func placePinOnMap(_ location: CLPlacemark) {
        mapView.addAnnotation(MKPlacemark(placemark: placemark))
        let locationCoordinate = placemark.location!.coordinate as CLLocationCoordinate2D
        setMapViewRegionAndScale(locationCoordinate)
    }
    
    func setMapViewRegionAndScale(_ location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }

}
