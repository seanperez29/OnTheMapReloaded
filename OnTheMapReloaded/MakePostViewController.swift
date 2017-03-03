//
//  MakePostViewController.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/2/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit

class MakePostViewController: UIViewController {

    @IBOutlet weak var locationTextField: CustomTextField!
    @IBOutlet weak var mediaTextField: CustomTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func findLocationPressed(_ sender: Any) {
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        let _ = navigationController?.popToRootViewController(animated: true)
    }

}
