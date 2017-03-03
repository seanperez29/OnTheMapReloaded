//
//  TabBarController.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/1/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    @IBAction func refreshStudentPosts(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UdacityClient.sharedInstance.taskForLogout { (success, error) in
            if success {
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                performUIUpdatesOnMain {
                    UdacityClient.sharedInstance.displayErrorAlert(self, title: "Unable to perform logout. Please try again.")
                }
            }
        }
        
    }
    
    @IBAction func postLocationPressed(_ sender: Any) {
        let myNavigationController = storyboard?.instantiateViewController(withIdentifier: "MakePostNavigationController") as! UINavigationController
        let controller = myNavigationController.topViewController as! MakePostViewController
        navigationController?.pushViewController(controller, animated: true)
    }
    

}
