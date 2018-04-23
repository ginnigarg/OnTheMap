//
//  Networking.swift
//  OnTheMap
//
//  Created by Guneet Garg on 22/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import MapKit

class Networking{
    
    static let sharedInstance = Networking()
    var students = [StudentInformation]()
    
    func getStudents(completionHandlerForStudentList: @escaping (_ result: [StudentInformation]?, _ error: NSError?)-> Void){
        let request = NSMutableURLRequest(url: NSURL(string: Constants.ConstantsParse.DefaultURL)! as URL)
        request.addValue(Constants.ConstantsParse.AppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ConstantsParse.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard(error == nil) else {
                completionHandlerForStudentList(nil, error as NSError?)
                return
            }
            
            guard let data = data else{
                completionHandlerForStudentList(nil, error as NSError?)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                completionHandlerForStudentList(nil, error as NSError?)
                return
            }
            
            var parsedResult: AnyObject
            do{
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                
            }catch{
                return
            }
            
            guard let resultArray = parsedResult["results"] as? [[String: AnyObject]] else{
                completionHandlerForStudentList(nil, error as NSError?)
                return
            }
            
            let students = StudentInformation.studentFromResult(results: resultArray)
            
            completionHandlerForStudentList(students, nil)
            
            
        }
        task.resume()
    }
    
    func getUserData(uniqueKey: String , completionHandlerForUserData: @escaping (_ success: Bool, _ error: NSError?)-> Void){
        let url = NSURL(string: Constants.ConstantsUdacity.ApiUserIdUrl+(uniqueKey))
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard (error == nil) else{
                completionHandlerForUserData(false, error as NSError?)
                return
            }
            
            guard let data = data else{
                completionHandlerForUserData(false, error as NSError?)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                completionHandlerForUserData(false, error as NSError?)
                return
                
                
            }
            let range = Range(5..<data.count)
            
            let newData = data.subdata(in: range)
            
            
            var parsedResult: AnyObject!
            do{
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            }catch{
                print("Error in getting user data: \(error)")
            }
            
            guard let user = parsedResult["user"] as? [String: AnyObject] else{
                completionHandlerForUserData(false, error as NSError?)
                return
            }
            
            guard let lastName = user["last_name"] as? String else{
                completionHandlerForUserData(false, error as NSError?)
                return
            }
            
            guard let firstName = user["nickname"] as? String else{
                completionHandlerForUserData(false, error as NSError?)
                return
            }
            
            User.sharedInstance.firstName = firstName
            User.sharedInstance.lastName = lastName
            
        }
        task.resume()
    }
    
    func postLocation(mapString: String, mediaUrl: String, pointAnnotation: MKAnnotation, completionHandlerForPostLocation: @escaping (_ success: Bool, _ error: NSError?)-> Void){
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")! as URL)
        request.httpMethod = "POST"
        request.addValue(Constants.ConstantsParse.AppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ConstantsParse.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(User.sharedInstance.uniqueKey!)\",\"firstName\": \"\(User.sharedInstance.firstName!)\",\"lastName\": \"\(User.sharedInstance.lastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaUrl)\",\"latitude\": \(pointAnnotation.coordinate.latitude), \"longitude\": \(pointAnnotation.coordinate.longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard (error == nil) else{
                completionHandlerForPostLocation(false, error as NSError?)
                return
            }
            guard let data = data else{
                completionHandlerForPostLocation(false, error as NSError?)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                completionHandlerForPostLocation(false, error as NSError?)
                return
            }
            
            var parsedResult: AnyObject
            do{
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            }catch{
                return
            }
            print(parsedResult)
            completionHandlerForPostLocation(true, nil)
        }
        task.resume()
    }
}
