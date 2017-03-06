//
//  TabBarController.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/1/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBOutlet weak var signInButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UdacityClient.sharedInstance.isStudentSignedIn {
            signInButton.title = "Logout"
        } else {
            signInButton.title = "Sign In"
        }
    }

    @IBAction func refreshStudentPosts(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        let button = sender as! UIBarButtonItem
        if button.title == "Sign In" {
            let controller = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            present(controller, animated: true, completion: nil)
        } else {
            UdacityClient.sharedInstance.taskForLogout { (success, error) in
                if success {
                    performUIUpdatesOnMain {
                        self.signInButton.title = "Sign In"
                        UdacityClient.sharedInstance.activeStudent = nil
                        UdacityClient.sharedInstance.isStudentSignedIn = false
                        UdacityClient.sharedInstance.displayErrorAlert(self, title: "You have successfully logged out")
                    }
                } else {
                    performUIUpdatesOnMain {
                        UdacityClient.sharedInstance.displayErrorAlert(self, title: "Unable to perform logout. Please try again.")
                    }
                }
            }
        }
    }
    
    @IBAction func postLocationPressed(_ sender: Any) {
        if UdacityClient.sharedInstance.isStudentSignedIn == false {
            navigateToMakePostViewController()
        } else {
            for student in UdacityClient.sharedInstance.studentLocations {
                if (student.firstName == UdacityClient.sharedInstance.activeStudent.firstName) && (student.lastName == UdacityClient.sharedInstance.activeStudent.lastName) {
                    UdacityClient.sharedInstance.activeStudent.doesPostAlreadyExist = true
                    UdacityClient.sharedInstance.activeStudent.objectID = student.objectID
                    let alert = UIAlertController(title: "You have already made a post", message: "Do you want to overwrite previous post?", preferredStyle: .alert)
                    let overwriteAction = UIAlertAction(title: "Overwrite", style: .default, handler: { (_) in
                        self.navigateToMakePostViewController()
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alert.addAction(overwriteAction)
                    alert.addAction(cancelAction)
                    present(alert, animated: true, completion: nil)
                }
            }
            navigateToMakePostViewController()
        }
    }
    
    func navigateToMakePostViewController() {
        let myNavigationController = storyboard?.instantiateViewController(withIdentifier: "MakePostNavigationController") as! UINavigationController
        let controller = myNavigationController.topViewController as! MakePostViewController
        navigationController?.pushViewController(controller, animated: true)
    }

}
