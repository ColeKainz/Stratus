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
    @IBOutlet weak var mapView: MKMapView!
    
    //Normal/Hybrid/Satellite Map Views
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }
    
    /*
    @IBOutlet weak var controller: UISegmentedControl!
    */
    //Zoom Bar
    /*
    @IBOutlet weak var slider: UISlider!
 */
    /*
    @IBOutlet weak var travelRadius: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    */
    
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
        
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* sliderChanged(sender: self)
        */
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        fetcher.attachObserver( observer: self )
        fetcher.setupSockets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //The zoom slider
    /*
    @IBAction func sliderChanged(sender: AnyObject) {
        let miles = Double(self.slider.value)
        
        travelRadius.text = "\(Int(round(miles))) miles"
        
        currentLocation.text = "CurrentLocation: \(latitude), \(longitude))"
    }
    */
    
    //Switching between Satellite/Hybrid Views
    /*
    @IBAction func segmentedControlAction(sender: UISegmentedControl!){
        switch (sender.selectedSegmentIndex){
        case 0:
            mapView.mapType = MKMapType.standard
        case 1:
            mapView.mapType = MKMapType.satellite
        default:
            mapView.mapType = MKMapType.hybrid
        }
    } */
    
    func onUpdate( stratusData: StratusDataFetcher.StratusDataStruct ) {
        battery.text = "Battery: " + String(stratusData.battery)
        gpsFixValid.text = "GPS Fix/Valid: " + String(stratusData.GPSValid)
        longitude.text = "Long: " + String(stratusData.longitude)
        latitude.text = "Lat: " + String(stratusData.latitude)
        groundSpeed.text = "Ground Speed: " + String(stratusData.groundSpeed)
        altitude.text = "Altitude: " + String(stratusData.altitude)
        verticalSpeed.text = "Vertical Speed: " + String(stratusData.verticalSpeed)
    }
    
    func onSocketError(error: Error) {
        switch error {
        case TimeoutError.timeout:
            let alert = UIAlertController( title: "Timeout",
                                          message: "The connection has timed out. Please check that you are connected to the Stratus device.",
                                          preferredStyle: UIAlertControllerStyle.alert )
            
            alert.addAction( UIAlertAction( title: "Retry", style: UIAlertActionStyle.default ) {
                (UIAlertAction) -> Void in
                    self.fetcher.refreshSockets()
                } )
            
            self.present(alert, animated: true, completion: nil)
            
        default:
            let alert = UIAlertController( title: "Error",
                                           message: "An error has occured: " + error.localizedDescription,
                                          preferredStyle: UIAlertControllerStyle.alert )
            
            alert.addAction( UIAlertAction( title: "Ok", style: UIAlertActionStyle.default ) {
                (UIAlertAction) -> Void in
                self.fetcher.refreshSockets()
            } )
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

