//
//  ViewController.swift
//  Speedometer
//
//  Created by Angelito Goulart on 12/10/15.
//  Copyright © 2015 AMG Labs. All rights reserved.
//

import UIKit
import CoreLocation

var speedUnits: [String] = ["ft/s", "km/h", "ko", "mph",  "m/s"]

class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var speedUnitPickerView: UIPickerView!
    
    @IBOutlet weak var topSpeedButton: UIBarButtonItem!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var locationManager = CLLocationManager()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var topSpeed:Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let maxSpeed:Double = defaults.doubleForKey("topSpeed")
        {
            topSpeed = maxSpeed
        }
        
        if let selectedUnit:Int = defaults.integerForKey("selectedUnit")
        {
            self.speedUnitPickerView.selectRow(selectedUnit, inComponent: 0, animated: true)
        }
        
        updateTopSpeed()
        
        self.speedUnitPickerView.delegate = self
        self.speedUnitPickerView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var speed:UInt = 0
        var convertedSpeed:Double = 0
        
        let speedUnit = speedUnits[speedUnitPickerView.selectedRowInComponent(0)]
        let rawSpeed:Double = locations[0].speed
        let accuracy: Double = locations[0].horizontalAccuracy
        
        if accuracy > 0 && accuracy < 80 {
         
            if rawSpeed > topSpeed {
                
                let latitude:Double = locations[0].coordinate.latitude
                let longitude:Double = locations[0].coordinate.longitude
                
                defaults.setDouble(rawSpeed, forKey: "topSpeed")
                defaults.setDouble(latitude, forKey: "topSpeedLatitude")
                defaults.setDouble(longitude, forKey: "topSpeedLongitude")
                
                topSpeed = rawSpeed
                updateTopSpeed()
                
            }
            
            convertedSpeed = appDelegate.getConvertedSpeed(rawSpeed, unit: speedUnit)
            speed = UInt(round(convertedSpeed))
            speedLabel.text = String(speed);
            
        }
        
    }
    
    func updateTopSpeed(){
        
        let speedUnit = speedUnits[speedUnitPickerView.selectedRowInComponent(0)]
        let speed = appDelegate.getConvertedSpeed(topSpeed, unit: speedUnit)
        topSpeedButton.title = String(UInt(round(speed))) + " " + speedUnit
        
    }

    @IBAction func resetTopSpeed(sender: AnyObject) {
        topSpeed = 0
        defaults.setDouble(topSpeed, forKey: "topSpeed")
        defaults.setDouble(0.0, forKey: "topSpeedLatitude")
        defaults.setDouble(0.0, forKey: "topSpeedLongitude")
        updateTopSpeed()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speedUnits.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return speedUnits[row] as String
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaults.setInteger(row, forKey: "selectedUnit")
        updateTopSpeed()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

