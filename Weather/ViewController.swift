//
//  ViewController.swift
//  Weather
//
//  Created by Julian Weiss on 7/16/20.
//  Copyright © 2020 Julian Weiss. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    // MARK: - properties
    // backend
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    var locationTitle = "Loading..." {
        didSet {
            navigationItem.prompt = locationTitle
        }
    }

    // frontend
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    // MARK: - funcs
    override func viewDidLoad() {
        super.viewDidLoad()

        // initial setup
        title = "Weather"
        navigationItem.prompt = locationTitle
        locationManager.delegate = self
        
        // add map view
        view.addSubview(mapView)
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // show up-to-date info when view becomes visible
        refreshLocation()
    }
}

// MARK: - update functions
extension ViewController {
    func refreshLocation() {
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}

//// MARK: - MKMapViewDelegate
//extension ViewController: MKMapViewDelegate {
//
//}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }
        

        let currentCoordinate = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let currentRegion = MKCoordinateRegion(center: currentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(currentRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
