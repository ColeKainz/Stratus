//
//  ViewController.swift
//  Stratus
//
//  Created by student on 2/8/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate, StratusObserver {

    var mapViewController: MapViewController!
    
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var transmitPowerLabel: UILabel!
    @IBOutlet weak var gpsFixValidLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var groundSpeedLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var verticalSpeedLabel: UILabel!
    @IBOutlet weak var groundTrackLabel: UILabel!
    
    let manager = CLLocationManager()
    var fetcher = StratusDataFetcher.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetcher.attachObserver( observer: self )
        fetcher.setupSockets()

        guard let mapController = childViewControllers.first as? MapViewController else {
            fatalError( "Check storyboard for missing MapViewController" )
        }
        mapViewController = mapController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Zoom Buttons (+ and -)
    //Setting zoom as global variable will allow methods in class to manipulate zoom value.
    @IBAction func zoomStepper(_ sender: UIStepper) {
        self.mapViewController.setZoom( zoom: Float(sender.value))
    }
    
    func onUpdate( stratusData: StratusDataFetcher.StratusDataStruct ) {
        let longitude = StratusModel.convertToCoords( coord: stratusData.longitude )
        let latitude = StratusModel.convertToCoords( coord: stratusData.latitude )
        let bearing = StratusModel.convertGroundTrack( rawBearing: stratusData.groundTrack )

        mapViewController.updateMarker( longitude: longitude, latitude: latitude, bearing: bearing )
        mapViewController.setAndUpdateFlightPath()

        batteryLabel.text = "Battery: " + String( stratusData.battery)
        transmitPowerLabel.text = "Signal: " + String( stratusData.transmitPower )

        gpsFixValidLabel.text = "GPS Fix/Valid: " + String( stratusData.GPSValid )

        longitudeLabel.text = "Long: " + String( format: "%.5f", longitude )
        latitudeLabel.text = "Lat: " + String( format: "%.5f", latitude )

        groundSpeedLabel.text = "Ground Speed: " + String( format: "%.5f",
            StratusModel.convertSpeed( rawSpeed: Int16( stratusData.groundSpeed ),
                measure: pow( 10, 3 ), time: "H" )
        )

        verticalSpeedLabel.text = "Vertical Speed: " + String( format: "%.5f",
            StratusModel.convertSpeed( rawSpeed: stratusData.verticalSpeed,
                measure: pow( 10, 3 ), time: "H" )
        )

        altitudeLabel.text = "Altitude: " + String( format: "%.5f",
            StratusModel.convertAltitude( rawAltitude: stratusData.altitude, measure: 1 )
        )

        groundTrackLabel.text = "Ori: " + String( bearing ) + "°"
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

