//
//  Backend.swift
//  Weather
//
//  Created by Julian Weiss on 7/16/20.
//  Copyright © 2020 Julian Weiss. All rights reserved.
//

import Foundation
import CoreLocation

class Helper {
    
    static func generateTitle(for location: CLLocation,_ callback: @escaping (String) -> (Void)) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            guard let placemark = placemarks?.first else {
                callback("")
                return
            }
            
            guard let name = placemark.name, let city = placemark.locality else {
                callback("")
                return
            }
            
            let title = "\(name), \(city)"
            callback(title)
        }
    }
}
