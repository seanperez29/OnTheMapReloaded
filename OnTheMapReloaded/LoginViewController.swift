//
//  LoginViewController.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 1/19/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        setUIEnabled(false)
        guard let username = usernameTextField.text, username != "", let password = passwordTextField.text, password != "" else {
            UdacityClient.sharedInstance.displayErrorAlert(self, title: "Please enter username and password")
            setUIEnabled(true)
            return
        }
        UdacityClient.sharedInstance.authenticateStudentLogin(username: username, password: password) { (success, errorString) in
            if success {
                performUIUpdatesOnMain {
                    self.completeLogin()
                    self.setUIEnabled(true)
                }
            } else {
                performUIUpdatesOnMain {
                    UdacityClient.sharedInstance.displayErrorAlert(self, title: errorString!)
                    self.setUIEnabled(true)
                }
            }
        }
    }
    
}

extension LoginViewController {
    
    func completeLogin() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "rootNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    func setUIEnabled(_ enabled: Bool) {
        loginButton.isEnabled = enabled
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        activityIndicator.isHidden = enabled
        if enabled {
            activityIndicator.stopAnimating()
            loginButton.alpha = 1.0
        } else {
            activityIndicator.startAnimating()
            loginButton.alpha = 0.5
        }
    }
}

