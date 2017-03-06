//
//  Student.swift
//  OnTheMapReloaded
//
//  Created by Sean Perez on 3/1/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation

class Student {
    
    private let _firstName: String
    private let _lastName: String
    private let _uniqueID: String
    var doesPostAlreadyExist = false
    var objectID: String?
    
    var firstName: String {
        return _firstName
    }
    
    var lastName: String {
        return _lastName
    }
    
    var uniqueID: String {
        return _uniqueID
    }
    
    init(firstName: String, lastName: String, uniqueID: String) {
        self._firstName = firstName
        self._lastName = lastName
        self._uniqueID = uniqueID
    }
    
}
