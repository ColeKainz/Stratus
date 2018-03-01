//
//  ViewController.swift
//  Stratus
//
//  Created by student on 2/8/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StratusObserver {

    @IBOutlet weak var battery: UILabel!
    @IBOutlet weak var gpsFixValid: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var groundSpeed: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var verticalSpeed: UILabel!

    var fetcher = StratusDataFetcher.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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

