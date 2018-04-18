//
//  MapController.swift
//  Stratus
//
//  Created by student on 4/10/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var compassButton: UIButton!
    
    var zoom: Float = 0
    
    var flightView = false
    var followMarker = true
    
    var markerPosition = CLLocationCoordinate2DMake( 0, 0 )
    var markerBearing: Double = 0
    
    let marker = GMSMarker()
    let linePath = GMSMutablePath()
    var polylinePath: GMSPolyline!
    
    override func viewDidLoad() {
        mapView.delegate = self
        
        polylinePath = GMSPolyline( path: linePath )
        polylinePath.map = mapView
        
        //Adding a KML map
        let path = Bundle.main.path( forResource: "states", ofType: "kml" )
        let url = URL( fileURLWithPath: path! )
        let kmlPaser = GMUKMLParser( url: url )
        kmlPaser.parse()
        
        //Rendering the KML Map
        let renderer = GMUGeometryRenderer(
            map: mapView,
            geometries: kmlPaser.placemarks,
            styles: kmlPaser.styles );
        renderer.render()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setZoom( zoom: Float ) {
        self.zoom = zoom
        mapView.animate( toZoom: zoom )
    }
    
    func updateMarker( longitude: Double, latitude: Double, bearing: Double ) {
        markerPosition = CLLocationCoordinate2DMake( latitude, longitude )
        markerBearing = bearing
        
        marker.position = markerPosition
        marker.icon = UIImage( named: "plane" )
        
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)

        marker.rotation = markerBearing
        marker.title = "Lat: " + String( format: "%.5f", latitude ) + " " + "Long: " + String( format: "%.5f", longitude )

        marker.tracksViewChanges = true
        marker.map = mapView
        
        //Center the camera every update, provided we are following the marker.
        if followMarker {
            centerCamera()
        }
    }
    
    //Adds Polyline that follows the user's position, updated with new position coordinates
    func setAndUpdateFlightPath() {
        linePath.add( markerPosition )
    }
 
    func centerCamera() {
        let camera = GMSCameraPosition.camera(
            withTarget: markerPosition,
            zoom: zoom )
        mapView.animate( to: camera )
        
        followMarker = true
        
        //If we are not following the marker, do not update the flight view
        if flightView {
            mapView.animate( toBearing: markerBearing )
        }
    }
    
    func mapView( _ mapView: GMSMapView, didChange position: GMSCameraPosition ) {
        compassButton.imageView?.transform = CGAffineTransform( rotationAngle: CGFloat( position.bearing ) )
        
        if !( position.target.latitude == markerPosition.latitude &&
            position.target.longitude == markerPosition.longitude ) {
            followMarker = false
        }
        
        if position.bearing != markerBearing {
            flightView = false
        }
    }
    
    @IBAction func compassOnClick( _ sender: Any ) {
        if mapView.camera.bearing != 0 {
            mapView.animate( toBearing: 0 )
            flightView = false
        } else {
            mapView.animate( toBearing: markerBearing )
            flightView = true
        }
        
        centerCamera()
    }
    
    @IBAction func centerCameraOnClick( _ sender: Any ) {
        centerCamera()
    }
}