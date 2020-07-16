//
//  MapViewController.swift
//  Weather
//
//  Created by Julian Weiss on 7/16/20.
//  Copyright © 2020 Julian Weiss. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
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
        map.isZoomEnabled = false
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    // MARK: - funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue

        // initial setup
        title = "Weather"
        navigationItem.prompt = locationTitle
        locationManager.delegate = self
        
        // add map view
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // add gesture recognizers
        tapGestureRecognizer.addTarget(self, action: #selector(handleTapGestureRecognized(sender:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // show up-to-date info when view becomes visible
        refreshLocation()
    }
}

// MARK: - ux handlers
extension MapViewController {
    @objc func handleTapGestureRecognized(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        dropPin(at: location)
        
        let weatherViewController = WeatherViewController(location)
        let modalNavigationController = UINavigationController(rootViewController: weatherViewController)
        navigationController?.present(modalNavigationController, animated: true, completion: nil)
    }
}

// MARK: - update functions
extension MapViewController {
    func refreshLocation() {
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func clearPins() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func dropPin(at location: CLLocation) {
        let pin: MKPointAnnotation = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        Helper.generateTitle(for: location) { result in
            pin.title = result
            self.mapView.addAnnotation(pin)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinate = view.annotation?.coordinate else {
            return
        }
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let weatherViewController = WeatherViewController(location)
        let modalNavigationController = UINavigationController(rootViewController: weatherViewController)
        navigationController?.present(modalNavigationController, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }

        let currentCoordinate = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let currentRegion = MKCoordinateRegion(center: currentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(currentRegion, animated: true)
        
        clearPins()
        dropPin(at: currentLocation)
        Helper.generateTitle(for: currentLocation) { result in
            self.locationTitle = result
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
