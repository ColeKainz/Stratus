//
//  ViewController.swift
//  Stratus
//
//  Created by student on 2/8/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, StratusObserver {

    //Map
    @IBOutlet var mapView: GMSMapView!
    
    //Zoom
  /*  @IBAction func slider(_ sender: AnyObject) {
        let miles = Double(self.slider.value)
        
        travelRadius.text = "\(Int(round(miles))) miles"
        
        currentLocation.text = "CurrentLocation: \(latitude), \(longitude))"
    } */
    

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
    //let polyline = GMSPolyline(path: path)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //slider(sender: self)
     //   slider(self)
        /*
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        */
        
//        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//
//        self.view = mapView
        
        
        fetcher.attachObserver( observer: self )
        fetcher.setupSockets()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        let path = Bundle.main.path(forResource: "states", ofType: "kml")
        let url = URL(fileURLWithPath: path!)
        let kmlPaser = GMUKMLParser(url: url)
        kmlPaser.parse()
        
        let renderer = GMUGeometryRenderer(
            map: mapView,
            geometries: kmlPaser.placemarks,
            styles: kmlPaser.styles);
        
        renderer.render()
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
    
    func onUpdate( stratusData: StratusDataFetcher.StratusDataStruct ) {
        battery.text = "Battery: " + String(stratusData.battery)
        gpsFixValid.text = "GPS Fix/Valid: " + String(stratusData.GPSValid)
        longitude.text = "Long: " + String(StratusModel.convertToCoords(coord: stratusData.latitude))
        latitude.text = "Lat: " + String(StratusModel.convertToCoords(coord: stratusData.longitude))
        groundSpeed.text = "Ground Speed: " + String(stratusData.groundSpeed)
        altitude.text = "Altitude: " + String(stratusData.altitude)
        verticalSpeed.text = "Vertical Speed: " + String(stratusData.verticalSpeed)
        
        let position = CLLocationCoordinate2DMake(
            StratusModel.convertToCoords(coord: stratusData.latitude),
            StratusModel.convertToCoords(coord: stratusData.longitude) )
        
        let camera = GMSCameraPosition.camera(
            withTarget: position,
            zoom: 5.5 )
        mapView.camera = camera
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

