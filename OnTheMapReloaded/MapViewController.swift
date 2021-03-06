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
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var studentLocations = [StudentLocation]()
    var annotations = [MKPointAnnotation]()
    var isFirstLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        mapViewIsFinishedLoadingUI(false)
        NotificationCenter.default.addObserver(self, selector: #selector(setStudentLocationsOnMap), name: NSNotification.Name(rawValue: "didSuccessfullyMakePost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
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
            self.mapViewIsFinishedLoadingUI(true)
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    func setStudentLocationsOnMap() {
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
            annotations.removeAll(keepingCapacity: true)
            getStudentsAndPlaceOnMap()
        } else {
            getStudentsAndPlaceOnMap()
        }
    }
    
    func getStudentsAndPlaceOnMap() {
        ParseClient.sharedInstance.getStudentLocations { (studentLocations, success, errorString) in
            if let studentLocations = studentLocations {
                UdacityClient.sharedInstance.studentLocations = studentLocations
                self.createStudentAnnotations(studentLocations)
            } else {
                UdacityClient.sharedInstance.displayErrorAlert(self, title: errorString!)
            }
        }
    }
    
    func reloadData() {
        setStudentLocationsOnMap()
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
            guard let subtitle = view.annotation?.subtitle else {
                UdacityClient.sharedInstance.displayErrorAlert(self, title: "Student has no url to share")
                return
            }
            guard let url = URL(string: subtitle!) else {
                UdacityClient.sharedInstance.displayErrorAlert(self, title: "Invalid URL shared by student.")
                return
            }
            if app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            } else {
                UdacityClient.sharedInstance.displayErrorAlert(self, title: "Unable to open provided url. Does not contain proper http:// prefix.")
            }
        }
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if !isFirstLoad {
            return
        } else {
            setStudentLocationsOnMap()
            isFirstLoad = false
        }
    }
    
    func mapViewIsFinishedLoadingUI(_ enabled: Bool) {
        activityIndicator.isHidden = enabled
        loadingView.isHidden = enabled
        if !enabled {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
