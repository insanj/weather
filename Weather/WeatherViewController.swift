//
//  WeatherViewController.swift
//  Weather
//
//  Created by Julian Weiss on 7/16/20.
//  Copyright © 2020 Julian Weiss. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UITableViewController {
    struct Model {
        let sections: [ModelSection]
        
        init(openWeatherData: [String: Any]) {
            var extractValue: (Any?) -> (String) = { value in
                return ""
            }
            extractValue = { value in
                guard let value = value else {
                    return ""
                }
                
                if let string = value as? String {
                    return string
                }
                
                if let integer = value as? Int {
                    return "\(integer)"
                }
            
                if let double = value as? Double {
                    return "\(double)"
                }
                
                if let bool = value as? Bool {
                    return "\(bool)"
                }
                
                if let array = value as? [[String: Any]] {
                    var arrayText = ""
                    for el in array {
                        for elKey in el.keys {
                            arrayText = "\(arrayText)\n\(elKey): \(extractValue(el[elKey]))"
                        }
                    }
                    
                    return arrayText
                }
                
                return ""
            }
            
            sections = openWeatherData.keys.sorted().compactMap({ (key) -> ModelSection in
                let value = openWeatherData[key]
                var rows = [WeatherMetadataCell.Model]()
                if let dictValue = value as? [String: Any] {
                    for dictKey in dictValue.keys {
                        let row = WeatherMetadataCell.Model(title: dictKey, detail: extractValue(dictValue[dictKey]))
                        rows.append(row)
                    }
                } else {
                    let row = WeatherMetadataCell.Model(title: extractValue(value), detail: "")
                    rows.append(row)
                }
                
                return ModelSection(rows: rows, title: key)
            })
        }
    }
    
    struct ModelSection {
        let rows: [WeatherMetadataCell.Model]
        let title: String
    }
    
    static func generateHeights(_ model: WeatherViewController.Model, _ view: UIView) -> [IndexPath: CGFloat] {
        var inProgress = [IndexPath: CGFloat]()
        
        for (sectionIndex, section) in model.sections.enumerated() {
            for (rowIndex, row) in section.rows.enumerated() {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                let generated = ("\(row.title)\n\(row.detail)" as NSString).boundingRect(with: CGSize(width: view.bounds.width - (WeatherMetadataCell.PADDING * 2.0), height: .infinity), options: .usesLineFragmentOrigin, attributes: [.font : WeatherMetadataCell.WEATHER_FONT], context: nil)
                inProgress[indexPath] = generated.size.height + (WeatherMetadataCell.PADDING * 2.0)
            }
        }
        
        return inProgress
    }
    
    // MARK: - properties
    let location: CLLocation
    let networker = OpenWeatherMapNetworker()
    
    var heights = [IndexPath: CGFloat]()
    var model = WeatherViewController.Model(openWeatherData: [:]) {
        didSet {
            heights = WeatherViewController.generateHeights(model, view)
            tableView.reloadData()
        }
    }
    
    
    // MARK: - functions
    init(_ location: CLLocation) {
        self.location = location
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Loading..."
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneButtonTapped))
        
        view.backgroundColor = .white
        tableView.register(WeatherMetadataCell.self, forCellReuseIdentifier: WeatherMetadataCell.REUSE_IDENTIFIER)
        tableView.allowsSelection = false

        Helper.generateTitle(for: location, { (result) -> (Void) in
            self.title = result
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshWeather()
    }
}

// MARK: networking, backend, etc
extension WeatherViewController {
    func refreshWeather() {
        networker.getWeather(for: location) { (responseData, error) -> (Void) in
            guard let responseData = responseData else {
                return
            }
            
            DispatchQueue.main.async {
                self.model = WeatherViewController.Model(openWeatherData: responseData)
            }
        }
    }
}

// MARK: - ux handlers
extension WeatherViewController {
    @objc func handleDoneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - table data source
extension WeatherViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = heights[indexPath] else {
            return 60.0 // educated guess, but this should NOT happen
        }
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherMetadataCell.REUSE_IDENTIFIER, for: indexPath) as? WeatherMetadataCell else {
            return UITableViewCell(style: .default, reuseIdentifier: nil) // will most likely crash; should not hapen
        }
        
        let cellModel = model.sections[indexPath.section].rows[indexPath.row]
        cell.model = cellModel
        return cell
    }
}
