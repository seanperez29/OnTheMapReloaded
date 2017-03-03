//
//  CustomButton.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/1/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
@IBDesignable

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }


}
