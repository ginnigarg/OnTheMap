//
//  StudentDataSource.swift
//  OnTheMap
//
//  Created by Guneet Garg on 22/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation

struct StudentInformation {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
    let createdAt: NSString
    let updatedAt: NSString
    
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary[Constants.ParseResponseKeys.firstName] as? String ?? "firstName"
        lastName = dictionary[Constants.ParseResponseKeys.lastName] as? String ?? "firstName"
        mapString = dictionary[Constants.ParseResponseKeys.mapString] as? String ?? ""
        mediaURL = dictionary[Constants.ParseResponseKeys.mediaURL] as? String ?? ""
        latitude = dictionary[Constants.ParseResponseKeys.latitude] as? Float ?? 0.0
        longitude = dictionary[Constants.ParseResponseKeys.longitude] as? Float ?? 0.0
        objectId = dictionary[Constants.ParseResponseKeys.objectID] as? String ?? ""
        uniqueKey = dictionary[Constants.ParseResponseKeys.uniqueKey] as? String ?? ""
        createdAt = dictionary[Constants.ParseResponseKeys.createdAt] as? NSString ?? ""
        updatedAt = dictionary[Constants.ParseResponseKeys.updatedAt] as? NSString ?? ""
    }
    
    static func studentFromResult(results: [[String: AnyObject]]) -> [StudentInformation]{
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
}

