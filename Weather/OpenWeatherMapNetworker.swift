//
//  OpenWeatherMapNetworker.swift
//  Weather
//
//  Created by Julian Weiss on 7/16/20.
//  Copyright © 2020 Julian Weiss. All rights reserved.
//

import Foundation
import CoreLocation


class OpenWeatherMapNetworker {
    static let API_KEY = "d42b7f80fd7162bfb6dd4963631861eb";
    static let BASE_URL_HOST = "api.openweathermap.org";
    
    enum Endpoint: NSString {
        case weatherForCoordinates = "/data/2.5/weather"
    }
    
    static func buildURL(_ endpoint: Endpoint, location: CLLocation) -> URL? {
        switch endpoint {
        case .weatherForCoordinates:
            var components = URLComponents()
            components.scheme = "https"
            components.host = OpenWeatherMapNetworker.BASE_URL_HOST
            components.path = endpoint.rawValue as String
            let latQueryItem = URLQueryItem(name: "lat", value: "\(location.coordinate.latitude.rounded())")
            let lonQueryItem = URLQueryItem(name: "lon", value: "\(location.coordinate.longitude.rounded())")
            let appIdItem = URLQueryItem(name: "appid", value: OpenWeatherMapNetworker.API_KEY)
            components.queryItems = [latQueryItem, lonQueryItem, appIdItem]
            let url = components.url?.absoluteURL
            return url
        }
    }
    
    fileprivate func get(url: URL, _ callback: @escaping (Data?, Error?) -> (Void)) {
        let session = URLSession.shared
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60.0)
        let task = session.dataTask(with: request) { (data, response, error) in
            callback(data, error)
        }
        
        task.resume()
    }
    
    func getWeather(for location: CLLocation, _ callback: @escaping ([String: Any]?, Error?) -> (Void)) {
        guard let weatherURL = OpenWeatherMapNetworker.buildURL(.weatherForCoordinates, location: location) else {
            callback(nil, nil)
            return
        }
        
        get(url: weatherURL) { (data, error) -> (Void) in
            guard let data = data else {
                callback(nil, error)
                return
            }
            
            do {
                guard let parsed = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    callback(nil, error)
                    return
                }
                
                callback(parsed, error)
            } catch (let jsonError) {
                callback(nil, jsonError)
            }
        }
    }
    
}
