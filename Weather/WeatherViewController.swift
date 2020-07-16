//
//  WeatherViewController.swift
//  Weather
//
//  Created by Julian Weiss on 7/16/20.
//  Copyright © 2020 Julian Weiss. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let location: CLLocation
    init(_ location: CLLocation) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneButtonTapped))
        
        title = "Loading..."
        Helper.generateTitle(for: location, { (result) -> (Void) in
            self.title = result
        })
    }
}

// MARK: - ux handlers
extension WeatherViewController {
    @objc func handleDoneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
