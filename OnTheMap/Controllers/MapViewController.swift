//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Guneet Garg on 22/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController:UIViewController, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getStudentList()
    }
    
    func getStudentList(){
        
        Networking.sharedInstance.getStudents {(result,error) in
            Networking.sharedInstance.students = result!
            performUIUpdatesOnMain {
                self.mapView.addAnnotations(self.populateMap())
            }
        }
    }
    
    func populateMap() -> [MKAnnotation]{
        
        var annotations = [MKPointAnnotation]()
        for student in Networking.sharedInstance.students {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let firstName = student.firstName
            let lastName = student.lastName
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = student.mediaURL
            annotations.append(annotation)
        }
        return annotations
    }
    
    private func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
        
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                if let url = URL(string: toOpen) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:],
                                                  completionHandler: {
                                                    (success) in
                                                    print("Open \(url): \(success)")
                        })
                    } else {
                        _ = UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
}
