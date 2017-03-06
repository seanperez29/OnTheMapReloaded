//
//  TableViewController.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/1/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var studentLocations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(retrieveAndDisplayStudentPosts), name: NSNotification.Name(rawValue: "didSuccessfullyMakePost"), object: nil)
        retrieveAndDisplayStudentPosts()
        NotificationCenter.default.addObserver(self, selector: #selector(retrieveAndDisplayStudentPosts), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    }
    
    func retrieveAndDisplayStudentPosts() {
        ParseClient.sharedInstance.getStudentLocations { (studentLocations, success, errorString) in
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                UdacityClient.sharedInstance.displayErrorAlert(self, title: "Could not access student locations")
            }
        }
    }
}

extension TableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! StudentCell
        let student = studentLocations[indexPath.row]
        cell.configureCell(student)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentLocations[indexPath.row]
        guard let mediaURL = student.mediaURL else {
            UdacityClient.sharedInstance.displayErrorAlert(self, title: "No media exists for this student")
            return
        }
        guard let url = URL(string: mediaURL) else {
            UdacityClient.sharedInstance.displayErrorAlert(self, title: "Could not obtian media URL")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UdacityClient.sharedInstance.displayErrorAlert(self, title: "Invalid URL: Unable to Open")
        }
    }
}
