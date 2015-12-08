//
//  MapViewController.swift
//  Speedometer
//
//  Created by Angelito Goulart on 15/10/15.
//  Copyright © 2015 AMG Labs. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var topSpeedMapView: MKMapView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var latitude:Double = 0
        var longitude:Double = 0
        var rawSpeed:Double = 0
        var selectedUnit:Int = 0
        
        latitude = defaults.doubleForKey("topSpeedLatitude") as Double
        longitude = defaults.doubleForKey("topSpeedLongitude") as Double
        rawSpeed = defaults.doubleForKey("topSpeed") as Double
        selectedUnit = defaults.integerForKey("selectedUnit") as Int
        
        let speedUnit:String = speedUnits[selectedUnit]
        let convertedSpeed:UInt = UInt(appDelegate.getConvertedSpeed(rawSpeed, unit: speedUnit))
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = String(convertedSpeed) + " " + speedUnit
        
        topSpeedMapView.addAnnotation(annotation)
        topSpeedMapView.setRegion(region, animated: true)
        topSpeedMapView.regionThatFits(region)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
