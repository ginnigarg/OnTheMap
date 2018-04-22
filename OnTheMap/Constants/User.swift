//
//  User.swift
//  OnTheMap
//
//  Created by Guneet Garg on 22/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation

class User {
    
    var sessionID: String? = nil
    var uniqueKey: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    
    static let sharedInstance = User()
    
}
