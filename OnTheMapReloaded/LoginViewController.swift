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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
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
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func udacitySignUp(sender: UIButton) {
        guard let url = URL(string: UdacityClient.Constants.UdacitySignupURL) else {
            UdacityClient.sharedInstance.displayErrorAlert(self, title: "Unable to obtain url")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func dismissKeyboard() {
        usernameTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
}

extension LoginViewController {
    
    func completeLogin() {
        UdacityClient.sharedInstance.isStudentSignedIn = true
        dismiss(animated: true, completion: nil)
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

