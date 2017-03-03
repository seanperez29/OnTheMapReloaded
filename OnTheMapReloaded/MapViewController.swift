//
//  MapViewController.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/1/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var studentLocations = [StudentLocation]()
    var annotations = [MKPointAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView.delegate = self
        ParseClient.sharedInstance.getStudentLocations { (studentLocations, success, errorString) in
            if let studentLocations = studentLocations {
                self.createStudentAnnotations(studentLocations)
            } else {
                UdacityClient.sharedInstance.displayErrorAlert(self, title: errorString!)
            }
        }
    }
    
    func createStudentAnnotations(_ students: [StudentLocation]) {
        for student in students {
            if let latitude = student.latitude, let longitude = student.longitude, let firstName = student.firstName, let lastName = student.lastName {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(firstName) \(lastName)"
                annotation.subtitle = student.mediaURL
                annotations.append(annotation)
            }
        }
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(self.annotations)
        }
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
