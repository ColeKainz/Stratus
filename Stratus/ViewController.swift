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
    @IBOutlet weak var groundSpeedLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var verticalSpeedLabel: UILabel!
    @IBOutlet weak var batteryImage: UIImageView!
    @IBOutlet weak var signalImage: UIImageView!
    
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
    
    func onUpdate( stratusData: StratusDataFetcher.StratusDataStruct ) {
        let longitude = StratusModel.convertToCoords( coord: stratusData.longitude )
        let latitude = StratusModel.convertToCoords( coord: stratusData.latitude )
        let bearing = StratusModel.convertGroundTrack( rawBearing: stratusData.groundTrack )

        mapViewController.updateMarker( longitude: longitude, latitude: latitude, bearing: bearing, GPSValid: stratusData.GPSValid )

        batteryLabel.text = String( stratusData.battery) + "%"
        updateBatteryImage(battery: stratusData.battery)
        updateTransmitPower(signal: stratusData.transmitPower)

        groundSpeedLabel.text = String( format: "%.0f",
            StratusModel.convertSpeed( rawSpeed: Int16( stratusData.groundSpeed ),
                measure: pow( 10, 3 ), time: "H" )
        )

        verticalSpeedLabel.text = String( format: "%.0f",
            StratusModel.convertSpeed( rawSpeed: stratusData.verticalSpeed,
                measure: pow( 10, 3 ), time: "H" )
        )
        
        altitudeLabel.text = String( format: "%.0f",
            StratusModel.convertAltitude( rawAltitude: stratusData.altitude, measure: 1 )
        )
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
    
    func updateBatteryImage(battery: UInt16) {
        if battery >= 60 {
            batteryImage.image = UIImage( named: "battery_full" )
        }
        else if battery >= 30 {
            batteryImage.image = UIImage( named: "battery_half" )
        }
        else if battery >= 1 {
            batteryImage.image = UIImage ( named: "battery_low" )
        }
        else {
            batteryImage.image = UIImage ( named: "battery_empty" )
        }
    }
    
    func updateTransmitPower (signal: UInt8){
        if signal == 0 || signal == 1 || signal == 2 {
            signalImage.image = UIImage ( named: "signal_full" )
        }
        else if signal == 3 || signal == 4 {
            signalImage.image = UIImage ( named: "signal_four" )
        }
        else if signal == 5 {
            signalImage.image = UIImage ( named: "signal_three" )
        }
        else if signal == 6 {
            signalImage.image = UIImage ( named: "signal_two" )
        }
        else if signal == 7 {
            signalImage.image = UIImage ( named: "signal_one" )
        }
        else {
            signalImage.image = UIImage ( named: "signal_zero" )
        }
    }
}

