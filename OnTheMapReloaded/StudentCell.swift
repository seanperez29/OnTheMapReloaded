//
//  StudentCell.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/2/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mediaLabel: UILabel!
    @IBOutlet weak var pinImageView: UIImageView!
    
    func configureCell(_ student: StudentLocation) {
        if let firstName = student.firstName, let lastName = student.lastName {
            nameLabel.text = "\(firstName) \(lastName)"
            mediaLabel.text = student.mediaURL
        }
        pinImageView.image = #imageLiteral(resourceName: "icon_pin")
    }
    

}
