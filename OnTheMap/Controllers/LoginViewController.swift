//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Guneet Garg on 08/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var infoText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 10
        submitButton.clipsToBounds = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            infoText.text = "Username or Password is Empty."
        }else{
            var request = URLRequest(url: URL(string: Constants.ConstantsUdacity.ApiSessionUrl)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonBody = "{\"udacity\": {\"username\": \"\(self.emailTextField.text!)\", \"password\": \"\(self.passwordTextField.text!)\"}}"
            request.httpBody = jsonBody.data(using: .utf8)
            let session = URLSession.shared
            //print(session)
            let task = session.dataTask(with: request) { data, response, error in
                
                func sendError(_ error: String){
                    print(error)
                    self.infoText.text = "Error with your user name or password"
                }
                
                guard (error == nil) else {
                    sendError("There was an error with your request: \(error!)")
                    return
                }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    sendError("Your request returned a status code other than 2xx!")
                    return
                }
                
                guard let data = data else {
                    sendError("No data was returned by the request!")
                    return
                }
                
                
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range)
                
                var parsedResults: AnyObject! = nil
                
                do{
                    parsedResults = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
                    print(parsedResults)
                }catch{
                    print("error parsing JSON \(LocalizedError.self)")
                }
                
                performUIUpdatesOnMain {
                    self.loginSuccessful()
                }
                
            }
            task.resume()
        }
    }

    @IBAction func SignUpPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: Constants.ConstantsUdacity.SignUpUrl)!, options: [:], completionHandler: nil)
    }
    private func loginSuccessful() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! TabBarController
        present(controller, animated: true, completion: nil)
    }


}

