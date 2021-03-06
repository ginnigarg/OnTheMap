//
//  Constants.swift
//  OnTheMap
//
//  Created by Guneet Garg on 09/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation

struct Constants{
    
    struct ConstantsUdacity {
        static let ApiSessionUrl = "https://www.udacity.com/api/session"
        static let ApiUserIdUrl = "https://www.udacity.com/api/users/"
        static let SignUpUrl = "https://www.udacity.com/account/auth#!/signup"
        static let NetworkProblem = "Not connected to a network. Check your network settings."
        static let IncorrectDetail = "Incorrect details. Enter correct details."
        static let NoData = "No data was found!"
    }
    
    
    struct ConstantsParse {
        static let ApiUrl = "https://parse.udacity.com/parse/classes"
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let DefaultURL = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt"
        static let NoName = "Anonymous"
    }
    
    struct ParseResponseKeys {
        static let objectID = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
    }
    
}




