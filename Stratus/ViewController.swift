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

<<<<<<< HEAD
    var mapViewController: MapViewController!
=======
    //Map
    @IBOutlet var mapView: GMSMapView!
    var mapController: MapController!
    @IBOutlet weak var plane: UIImageView!
    //Zoom Buttons (+ and -)
    //Setting zoom as global variable will allow methods in class to manipulate zoom value
    
    
    @IBAction func zoomStepper(_ sender: UIStepper) {
        self.mapController.setZoom( zoom: Float(sender.value))
    }
    
    //The only things that should be changed are
    //zoom, viewingangle (optional), and bearing
    @IBAction func trackingMode(_ sender: UIButton) {
        //stratusData: StratusDataFetcher.StratusDataStruct
        
        //mapView.settings.myLocationButton = true
        
    }
    
    func trackingMode(bearing: Double) {
        let trackingCamera = GMSCameraPosition.camera(withLatitude: -33,
                                                      longitude: 151,
                                                      zoom: 6,
                                                      bearing: bearing,
                                                      viewingAngle: 45)
        mapView.camera = trackingCamera
    }
    
    func trackingCamera(bearing: Double){
    }
    
    
    /*
    @IBAction func zoomIn( _ sender: Any ) {
        self.mapController.zoomIn();
    }
    
    @IBAction func zoomOut( _ sender: Any ) {
        self.mapController.zoomOut();
    }
 */
    
    /*
    @IBAction func zoomSlider( _ sender: UISlider ) {
        self.mapController.setZoom( zoom: sender.value )
    }
 */
>>>>>>> 5e164aece02844083852369658ff833f72edb9a3
    
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
        
<<<<<<< HEAD
        guard let mapController = childViewControllers.first as? MapViewController else {
            fatalError( "Check storyboard for missing MapViewController" )
        }
        mapViewController = mapController
=======
        mapController = MapController( map: mapView, zoom: 5.5, zoomIncrement: 1 )
        
        //Show user location
        mapView.isMyLocationEnabled = true
        //User location button
        mapView.settings.myLocationButton = true
        //Compass button
        mapView.settings.compassButton = true

        //Adding a KML map
        let path = Bundle.main.path(forResource: "states", ofType: "kml")
        let url = URL(fileURLWithPath: path!)
        let kmlPaser = GMUKMLParser(url: url)
        kmlPaser.parse()
        
        //Rendering the KML Map
        let renderer = GMUGeometryRenderer(
            map: mapView,
            geometries: kmlPaser.placemarks,
            styles: kmlPaser.styles);
        mapView.isMyLocationEnabled = true //for testing
        renderer.render()
>>>>>>> 5e164aece02844083852369658ff833f72edb9a3
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
        
        mapController.trackingMode(bearing: bearing)
        
        
        batteryLabel.text = "Battery: " + String( stratusData.battery)
        transmitPowerLabel.text = "Signal: " + String( stratusData.transmitPower )
        
        gpsFixValidLabel.text = "GPS Fix/Valid: " + String( stratusData.GPSValid )
        
        longitudeLabel.text = "Long: " + String( format: "%.5f", longitude )
        latitudeLabel.text = "Lat: " + String( format: "%.5f", latitude )
        
        groundSpeedLabel.text = "Ground Speed: " + String( format: "%.5f",
            StratusModel.convertSpeed( rawSpeed: Int16( stratusData.groundSpeed ),
                measure: pow( 10, 3 ), time: "H" )
        ) + " KM/H"
        
        verticalSpeedLabel.text = "Vertical Speed: " + String( format: "%.5f",
            StratusModel.convertSpeed( rawSpeed: stratusData.verticalSpeed,
                measure: pow( 10, 3 ), time: "H" )
        ) + " KM/H"
        
        altitudeLabel.text = "Altitude: " + String( format: "%.5f",
            StratusModel.convertAltitude( rawAltitude: stratusData.altitude, measure: 1 )
        ) + " m"
        
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

