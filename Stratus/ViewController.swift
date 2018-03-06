//
//  ViewController.swift
//  Stratus
//
//  Created by student on 2/8/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, StratusObserver {

    //Map
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var battery: UILabel!
    @IBOutlet weak var gpsFixValid: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var groundSpeed: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var verticalSpeed: UILabel!

    let manager = CLLocationManager()
    var fetcher = StratusDataFetcher.instance
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        fetcher.attachObserver( observer: self )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update( stratusData: StratusDataFetcher.StratusDataStruct ) {
        battery.text = "Battery: " + String(stratusData.battery)
        gpsFixValid.text = "GPS Fix/Valid: " + String(stratusData.GPSValid)
        longitude.text = "Long: " + String(stratusData.longitude)
        latitude.text = "Lat: " + String(stratusData.latitude)
        groundSpeed.text = "Ground Speed: " + String(stratusData.groundSpeed)
        altitude.text = "Altitude: " + String(stratusData.altitude)
        verticalSpeed.text = "Vertical Speed: " + String(stratusData.verticalSpeed)
    }
}

