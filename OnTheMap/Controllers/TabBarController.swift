//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Guneet Garg on 22/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    @IBAction func finishUserSession(_ sender: Any) {
        var request = URLRequest(url: URL(string: Constants.ConstantsUdacity.ApiSessionUrl)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            performUIUpdatesOnMain {
                self.logOut()
            }
        }
        task.resume()
    }
    
    private func logOut() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        present(controller, animated: true, completion: nil)
    }
    
}
