//
//  Current.swift
//  Stormy
//
//  Created by Jon-Tait Beason on 10/3/14.
//  Copyright (c) 2014 IOBI Education Systems. All rights reserved.
//

import Foundation
import UIKit

struct Current {
    var currentTime: String?
    var temperature: Int
    var humidity: Double
    var precipProbability: Double
    var summary: String
    var icon: UIImage?
    
    init (weatherDictionary: NSDictionary) {
        let currentWeather = weatherDictionary["currently"] as
            NSDictionary
        
        // downcast because of type unknown in dictionary
        temperature = currentWeather["temperature"] as Int
        humidity = currentWeather["humidity"] as Double
        precipProbability = currentWeather["precipProbability"] as Double
        summary = currentWeather["summary"] as String
        
        let currentTimeIntValue = currentWeather["time"] as Int
        currentTime = dateStringFromUnixTime(currentTimeIntValue)
        
        let iconString = currentWeather["icon"] as String
        icon = weatherIconString(iconString)
    }
    
    // converts date from Unix Time
    func dateStringFromUnixTime(unixTime: Int) -> String {
        
        //let timeInseconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: NSTimeInterval(unixTime))
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        
        return dateFormatter.stringFromDate(weatherDate)
        
    }
    
    func weatherIconString(stringIcon: String) -> UIImage {
        var imageName: String
        
        switch stringIcon {
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }
        
        var iconImage = UIImage(named: imageName)
        
        return iconImage
    }
    
    
    
}