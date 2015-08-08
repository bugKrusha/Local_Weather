//
//  ViewController.swift
//  Stormy
//
//  Created by Jon-Tait Beason on 10/3/14.
//  Copyright (c) 2014 IOBI Education Systems. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    
    
    private let APIKey = "ffcb4e7176ec0ab01fe3d87ad3bb4fc0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        refreshActivityIndicator.hidden = true
        
        // get weather data
        getCurrentWeatherData()
    }
    
    func getCurrentWeatherData() -> Void {
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(APIKey)/")
        let forcastURL = NSURL(string: "38.349776,-81.634274", relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask =
        sharedSession.downloadTaskWithURL(forcastURL,
            completionHandler: { (location: NSURL!, response:
                NSURLResponse!, error: NSError!) -> Void in
                
                if (error == nil) {
                    let dataObject = NSData(contentsOfURL: location)
                    let weatherDictionary: NSDictionary =
                    NSJSONSerialization.JSONObjectWithData(dataObject, options: nil, error: nil) as
                    NSDictionary
                    
                    let currentWeather = Current(weatherDictionary: weatherDictionary)
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        self.temperatureLabel.text = "\(currentWeather.temperature)"
                        self.iconView.image = currentWeather.icon!
                        self.currentTimeLabel.text = "\(currentWeather.currentTime!)"
                        self.humidityLabel.text = "\(currentWeather.humidity)"
                        self.rainLabel.text = "\(currentWeather.precipProbability)"
                        self.summaryLabel.text = "\(currentWeather.summary)"
                        
                        // stop refresh
                        self.refreshActivityIndicator.stopAnimating()
                        self.refreshActivityIndicator.hidden = true
                        self.refreshButton.hidden = false
                    })
                } else {
                    let networkIssueController = UIAlertController(title: "Error", message: "Unable to download data. Connectivity error!", preferredStyle: .Alert)
                    
                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    networkIssueController.addAction(okButton)
                    
                    let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    networkIssueController.addAction(cancelButton)
                    
                    
                    self.presentViewController(networkIssueController, animated:true, completion: nil)
                    
                    // get back onto the main queue
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // stop refresh
                        self.refreshActivityIndicator.stopAnimating()
                        self.refreshActivityIndicator.hidden = true
                        self.refreshButton.hidden = false
                    })

                }
                
                
        })
        downloadTask.resume()
    }

    @IBAction func refresh() {
        getCurrentWeatherData()
        
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

